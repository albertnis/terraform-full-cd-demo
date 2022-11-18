# Terraform full CD demo

A demonstration of "review apps" and production deployment flow built in Terraform

## Workflow

1. Open a branch with work in progress. To deploy the branch into its own environment, open a PR and tag it with "review app". While the "review app" tag is present, commits on that branch will result in a new release. When the label is removed, the terraform deployment will be destroyed.
1. Merge the PR to `main`
1. To initiate a deployment, push a tag starting with `v` (for example: `v0.0.5`). This will initiate a deployment to production via staging, with manual approval before proceeding to production.
1. To promote the deployment, find the action which deployed to staging and promote it to production.

## Decisions

- **For PR deployments, use head commit, not merge commit**. This has the benefit of avoiding conflict handling and ensuring each deployment corresponds to a real commit in the repository. The downside is the previews will be less reflective of the app state post-merge.
- **Only deploy to staging when a tag is pushed**. This has the benefit of more control over how and when things are released, and ensures a single version can be tracked and tested through staging all the way to production. Automatically deploying to staging may be a better option if there is a high degree of test automation and no vigorous versioning is required on the end product.
- **Manually gatekeep production deployments**. I think manual but trivial production deployments (ie "one-button" deployments) are the sweet spot for auditing and review purposes. But you may wish to automate this all the way through, especially if automated system test coverage is very high.

## Known issues

- After PR close, an action will attempt to remove the "review app" label
   - If the label is present it will remove the label but for some reason this does not trigger the "unlabelled" webhook which initiates terraform destroy
   - If the label is not present it will error out
