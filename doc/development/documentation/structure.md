---
description: Learn the how to correctly structure GitLab documentation.
---

# Documentation structure

For consistency throughout the documentation, it's important to maintain the same
structure among the docs.

Before getting started, read through the following docs:

- [Contributing to GitLab documentation](index.md#contributing-to-docs)
- [Merge requests for GitLab documentation](index.md#merge-requests-for-gitlab-documentation)
- [Branch naming for docs-only changes](index.md#branch-naming)
- [Documentation directory structure](index.md#documentation-directory-structure)
- [Documentation style guidelines](styleguide.md)
- [Documentation workflow](workflow.md)

## Documentation blurb

Every document should include:

- **Feature name**: defines an intuitive name for the feature that clearly
states what it is
- **Feature overview** and description: describe what is it, why should one
use it, and what it does
- **Use cases**: describes real use case scenarios for that feature
- **Requirements**: describes what one needs to have set up to be able to
use the feature or to follow along with the tutorial. Define the assumptions
to follow along (e.g., be familiar with GitLab CI/CD, an account on a
third-party service, dependencies installed, etc) at the beginning of the doc
- **Instructions**: clearly describes the steps to use that feature, with no gaps
- **Troubleshooting** guide (recommended but not required): if you know beforehand what issues
one might have when setting it up, or when something is changed, or on upgrading, it's
important to describe it too. Think of things that may go wrong and include them in the
docs. This is important to minimize request for support, and to avoid comments with
questions that you know someone might ask. Answering them beforehand only makes your
document better and more approachable.

### Feature overview and use cases

Every major feature (regardless if present in GitLab Community or Enterprise editions)
should present, at the beginning of the document, two main sections: **overview** and
**use cases**. Every GitLab EE-only feature should also contain these sections.

**Overview**: as the name suggests, the goal here is to provide an overview of the feature.
Describe what is it, what it does, why it is important/cool/nice-to-have,
what problem it solves, and what you can do with this feature that you couldn't
do before.

**Use cases**: provide at least two, ideally three, use cases for every major feature.
You should answer this question: what can you do with this feature/change? Use cases
are examples of how this feature or change can be used in real life.

Examples:
- CE and EE: [Issues](../user/project/issues/index.md#use-cases)
- CE and EE: [Merge Requests](../user/project/merge_requests/index.md#overview)
- EE-only: [Geo](https://docs.gitlab.com/ee/gitlab-geo/README.html#overview)
- EE-only: [Jenkins integration](https://docs.gitlab.com/ee/integration/jenkins.md#overview)

Note that if you don't have anything to add between the doc title (`<h1>`) and
the header `## Overview`, you can omit the header, but keep the content of the
overview there.

> **Overview** and **use cases** are required to **every** Enterprise Edition feature,
and for every **major** feature present in Community Edition.

### Discoverability

Your new document will be discoverable by the user only if:

- Crosslinked from the higher-level index (e.g., Issue Boards docs
should be linked from Issues; Prometheus docs should be linked from
Monitoring; CI/CD tutorials should be linked from CI/CD examples)
  - When referencing other GitLab products and features, link to their
respective docs; when referencing third-party products or technologies,
link out to their external sites, documentation, and resources.
- The headings are clear. E.g., "App testing" is a bad heading, "Testing
an application with GitLab CI/CD" is much better. Think of something
someone will search for and use these keywords in the headings.

## Documentation template for new docs

To start a new document, respect the file tree and file name,
as well as the style guidelines. Use the following template:

```md
---
description: "short document description." # Up to ~200 chars long. They will be displayed in Google Search Snippets.
---

# Feature Name **[TIER]** (1)

> Introduced in GitLab Tier X.Y (2)

A short description for the feature (can be the same used in the frontmatter's
`description`).

## Overview

To write the feature overview, you should consider answering the following questions:

- What is it?
- Who is it for?
- What is the context in which it is used and are there any prerequisites/requirements?
- What can the user do with it? (Be sure to consider multiple audiences, like GitLab admin and developer-user.)
- What are the benefits to using it over any alternatives?

## Use cases

Describe one to three use cases for that feature. Give real-life examples.

## Requirements

State any requirements for using the feature and/or following along with the tutorial.

The only assumption that is redundant and doesn't need to be mentioned is having an account
on GitLab.

## Instructions

- Write a step-by-step guide, with no gaps between the steps
- Start with an h2 (`##`), break complex steps into small steps using
subheadings h3 > h4 > h5 > h6. _Never skip the hierarchy level, such
as h2 > h4_, as it will break the TOC and may affect the breadcrumbs.
- Use short and descriptive headings (up to 64 chars). You can use one
single heading `## How it works` when the feature is simple and the
document is short.
- Be clear, concise, and stick to the goal of the doc: explain how to
use that feature.
- Use inclusive language and avoid jargons, as well as uncommon and
fancy words. The docs should be clear and very easy to understand.
- Write in the 3rd person (use "we", "you", "us", "one", instead of "I" or "me")
- Always provide internal and external reference links
- Always link the doc from its higher-level index
```

Notes:

- (1): Apply the [tier badges](styleguide.md#product-badges) accordingly
- (2): Apply the correct format for the [GitLab version introducing the feature](styleguide.md#gitlab-versions-and-tiers)

