require 'spec_helper'

describe SiteStatistic do
  describe '.fetch' do
    context 'existing record' do
      let!(:statistics) { described_class.create(repositories_count: 999, wikis_count: 555) }

      it 'returns existing SiteStatistic model' do
        expect(described_class.fetch).to be_a(described_class)
        expect(described_class.fetch).to eq(statistics)
      end
    end

    context 'non existing record' do
      it 'returns existing SiteStatistic model' do
        expect(described_class.first).to be_nil
        expect(described_class.fetch).to be_a(described_class)
      end
    end
  end

  describe '.track' do
    context 'with allowed attributes' do
      it 'increases the attribute counter' do
        expect { described_class.track('repositories_count') }.to change { described_class.fetch.repositories_count }.by(1)
        expect { described_class.track('wikis_count') }.to change { described_class.fetch.wikis_count }.by(1)
      end
    end

    context 'with not allowed attributes' do
      it 'returns error' do
        expect { described_class.track('something_else') }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.untrack' do
    context 'with allowed attributes' do
      before do
        described_class.fetch.update(repositories_count: 555, wikis_count: 444)
      end

      it 'decreases the attribute counter' do
        expect { described_class.untrack('repositories_count') }.to change { described_class.fetch.repositories_count }.by(-1)
        expect { described_class.untrack('wikis_count') }.to change { described_class.fetch.wikis_count }.by(-1)
      end
    end

    context 'with not allowed attributes' do
      it 'returns error' do
        expect { described_class.untrack('something_else') }.to raise_error(ArgumentError)
      end
    end
  end
end
