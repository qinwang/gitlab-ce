# Documentation process at GitLab

TBA: introduction

## Requirements

It is required to deliver documentation whenever:

- A new feature is shipped
- There are changes to the UI
- It changes a process, workflow, or feature previously documented

Documentation is not required when a feature is changed on the backend
only and does not affect the user directly.

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
third-party service, dependencies installed, etc)
- Tutorial: clearly describes the steps to use that feature, with no gaps
- Troubleshooting guide (recommended but not required): if you know beforehand what issues
one might have when setting it up, or when something is changed, or on upgrading, it's
important to describe it too. Think of things that may go wrong and include them in the
docs. This is important to minimize request for support, and to avoid comments with
questions that you know someone might ask. Answering them beforehand only makes you
document better and more approachable.

## File tree and file name

TBA

- When you create a new directory, always start with an `index.md` file.
Do not use another file name and do not create `README.md` files
- Max screenshot size: 100KB

## Discoverability

Your new document will be discoverable by the user only if:

- Crosslinked from the higher-level index (e.g., Issue Boards docs
should be linked from Issues; Prometheus docs should be linked from
Monitoring; CI/CD tutorials should be linked from CI/CD examples)
- The headers are clear. E.g., "App testing" is a bad header, "Testing
an application with GitLab CI/CD" is much better. Think of something
someone will search for and use these keywords in the headers.

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
2. Developer (dev): in the feature MR, add:
  - Feature name, overview/description, use cases from the feature issue
  - Tutorial: write how to use the feature, step by step, with no gaps.
  - Crosslink: link with internal docs and external resources (if applicable)
  - Index: link the new doc or the new header from the higher-level index for [discoverability](#discoverability)
  - Screenshots: when necessary, add screenshots for:
      - Illustrating a step of the process
      - Indicating the location of a navigation menu
  - Label the MR with "Documentation"
  - Assign the PM for review
  - When done, mention the `@gl\-docsteam` in the MR asking for review [note: do we want/need this?]
  - **Due date**: feature freeze date and time
  - 2.1. If you can't add the docs within the feature MR:
      - Create a new issue with the title: "Docs: add documentation for 'Feature Name'"
      - Label the issue with: "Documentation", "Deliverable", "docs-P1", "Pick into X.Y", "docs-follow-up", "product-label" (product label == CI/CD, Pages, Prometheus, etc) [note: do we want this new label "docs-follow-up" to subscribe to it?]
      - Add the correct milestone
      - 2.1.2 Create a new MR shipping the doc
          - Add the same labels and milestone as you did for the issue
          - Assign the PM for review
          - When done, mention the `@gl\-docsteam` in the MR asking for review [note: do we want this?]
          - **Due date:** 6 working days before the 22nd for a given release. This date matches the
            deadline for general contributions for the release post. [note: do we want this?]
3. Technical Writer (TW):
  - Review the documentation for:
      - Clarity
      - Relevance (make sure the content is appropriate given the impact of the feature)
      - Location (make sure the doc is in the correct dir and has the correct name)
      - Typos and broken links
      - Improvements to the content

TBA: issue and MR description templates as part of the process

### Skip the review process

When there's an insignificant change to the docs, you can skip the review
of the PM. Add the same labels as you would for a regular doc change and
assign the correct milestone. In these cases, assign a technical writer
for approval/merge, or mention `@gl\-docsteam` in case you don't know
which tech writer to assign for. [note: do we want this?]

Are considered irrelevant changes:

- TBA

## New features vs feature updates

- TBA:
  - Describe the difference between new features and feature updates
  - Creating a new doc vs updating an existing doc

## Documentation template for new docs

To start a new document, respect the file tree and file name, and use
the following template:

```md
# Feature Name **[TIER]** (1)

> Introduced in GitLab Tier X.Y (2)

## Overview

To write the feature overview, one should consider answering the following questions:

- What is it?
- Why is it cool?
- What one can do with it that couldn't do without it?

## Use cases

Describe one to three real use cases for that feature. Give real life examples.

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
