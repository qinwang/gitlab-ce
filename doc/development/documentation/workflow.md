# Documentation process at GitLab

At GitLab, developers contribute new or updated documentation along with their code, but product managers and technical writers also have essential roles in the process.

- Product Managers (PMs): in the issue for all new and updated features,
PMs include specific documentation requirements that the developer who is
writing or updating the docs must meet, along with feature descriptions
and use cases. They call out any specific areas where collaborating with
a technical writer is recommended, and usually act as the first reviewer
of the docs.
- Developers: author documentation and merge it on time (up to a week after
the feature freeze).
- Technical Writers: review each issue to ensure PM's requirements are complete,
help developers with any questions throughout the process, and act as the final
reviewer of all new and updated docs content before it's merged.

## Requirements

Documentation must be delivered whenever:

- A new feature is shipped
- There are changes to the UI
- A process, workflow, or previously documented feature is changed

Documentation is not required when a feature is changed on the backend
only and does not directly affect the way that any regular user or
administrator would interact with GitLab.

### Skip the review process

When there's an insignificant change to the docs, you can skip the review
of the PM. Add the same labels as you would for a regular doc change and
assign the correct milestone. In these cases, assign a technical writer
for approval/merge, or mention `@gl\-docsteam` in case you don't know
which tech writer to assign for. [note: do we want this?]

The following are considered insignificant changes:

- Typos or corrections of any type (grammar, broken links, etc)
- Changes to the backend only (that does not affect the user/admin directly)
- TBA (what else?)

## Documentation blurb

Every document should include:

- Feature name: defines an intuitive name for the feature that clearly
states what it is
- Feature overview and description: describe what is it, why should one
use it, and what it does
- Use cases: describes real use case scenarios for that feature
- Requirements: describes what one needs to have set up to be able to
use the feature or to follow along with the tutorial. Define the assumptions
to follow along (e.g., be familiar with GitLab CI/CD, an account on a
third-party service, dependencies installed, etc) at the beginning of the doc
- Tutorial: clearly describes the steps to use that feature, with no gaps
- Troubleshooting guide (recommended but not required): if you know beforehand what issues
one might have when setting it up, or when something is changed, or on upgrading, it's
important to describe it too. Think of things that may go wrong and include them in the
docs. This is important to minimize request for support, and to avoid comments with
questions that you know someone might ask. Answering them beforehand only makes your
document better and more approachable.

## Documentation files

- When you create a new directory, always start with an `index.md` file.
Do not use another file name and **do not** create `README.md` files
- Do not use special chars and spaces, or capital letters in file names,
directory names, branch names, and anything that generates a path.
- Max screenshot size: 100KB
- We do not support videos (yet)

## Discoverability

Your new document will be discoverable by the user only if:

- Crosslinked from the higher-level index (e.g., Issue Boards docs
should be linked from Issues; Prometheus docs should be linked from
Monitoring; CI/CD tutorials should be linked from CI/CD examples)
- The heading are clear. E.g., "App testing" is a bad heading, "Testing
an application with GitLab CI/CD" is much better. Think of something
someone will search for and use these keywords in the headings.

## Documentation review and feedback

Every relevant documentation change must be reviewed by a Technical Writer,
to avoid redundancy, duplications, bad locations, typos, broken links, misinformation,
and to ensure the document is clear and discoverable. If you don't know who to
ping, ping any of them, or all of them (`@gl\-docsteam`). [note: do we want this?]

If you need any help to choose the correct place for a doc, for start
writing it, or any other help, ping a Technical Writer on your issue, MR, or on Slack.

## Documentation workflow

1. Product Manager (PM): in the feature issue, add:
  - Feature name
  - Feature overview/description
  - Feature use cases
  - The documentation requirements for the developer working on the docs
    - What new page, new subsection of an existing page, or other update to an existing page/subsection is needed.
    - Just one page/section/update or multiple (perhaps there's an end user and admin change needing docs, or we need to update a previously recommended workflow, or we want to link the new feature from various places; consider and mention all ways documentation should be affected
    - Suggested title of any page or subsection, if applicable
  - Label the issue with Documentation (anything else?)

2. Developer (dev): in the feature MR, add:
  - The documentation containing:
    - Feature name, overview/description, use cases from the feature issue
    - Tutorial: write how to use the feature, step by step, with no gaps.
    - Crosslink: link with internal docs and external resources (if applicable)
    - Index: link the new doc or the new heading from the higher-level index for [discoverability](#discoverability)
    - Screenshots: when necessary, add screenshots for:
      - Illustrating a step of the process
      - Indicating the location of a navigation menu
  - Label the MR with "Documentation"
  - Assign the PM for review
  - When done, mention the `@gl\-docsteam` in the MR asking for review
  - **Due date**: feature freeze date and time
  - 2.1. If you can't add the docs within the feature MR:
      - Create a new issue with the title: "Docs: add documentation for 'Feature Name'"
      - Label the issue with: `Documentation`, `Deliverable`, `docs-P1`, `Pick into X.Y`, `missed-deliverable`, `<product-label>` (product label == CI/CD, Pages, Prometheus, etc)
      - Add the correct milestone
      - 2.1.2 Create a new MR shipping the doc
          - Add the same labels and milestone as you did for the issue
          - Assign the PM for review
          - When done, mention the `@gl\-docsteam` in the MR asking for review [note: do we want this?]
          - **Due date** for merging `missed-deliverable` MRs: on the **14th** of each month
3. Technical Writer (TW): review the documentation for:
  - Clarity
  - Relevance (make sure the content is appropriate given the impact of the feature)
  - Location (make sure the doc is in the correct dir and has the correct name)
  - Typos and broken links
  - Improvements to the content

TBA: issue and MR description templates as part of the process

## New features vs feature updates

- TBA:
  - Describe the difference between new features and feature updates
  - Creating a new doc vs updating an existing doc

## Documentation template for new docs

To start a new document, respect the file tree and file name,
as well as the style guidelines. Use the following template:

```md
# Feature Name **[TIER]** (1)

> Introduced in GitLab Tier X.Y (2)

## Overview

To write the feature overview, one should consider answering the following questions:

- What is it?
- Who is it for?
- What is the context in which it is used and are there any prerequisites/requirements?
- What can the user do with it? (Be sure to consider multiple audiences, like GitLab admin and developer-user.)
- What are the benefits to using it over any alternatives?

## Use cases

Describe one to three use cases for that feature. Give real life examples.

## Requirements

State any requirements for using the feature and/or following along with the tutorial.

The only assumption that is redundant and doesn't need to be mentioned is having an account
on GitLab.

## Tutorial

- Step-by-step guide, with no gaps between the steps.
- Be clear, concise, and stick to the goal of the doc: explain how to use that feature. Do not use fancy words.
- Use inclusive language and avoid jargons and uncommon words. The docs should be clear and very easy to understand.
- Write in the 3rd person ("we", "you", "us", "one", instead of "I" or "me")
- Always provide internal and external reference links
- Always link the doc from its higher-level index
```

TBA: brief example and crosslink (1) and (2)

TBA: crosslink with doc index and style guidelines
