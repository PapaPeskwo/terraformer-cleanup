# Terraformer Export Cleanup

Uses the [docker/cagent](https://github.com/docker/cagent) tool to clean [terraformer](https://github.com/GoogleCloudPlatform/terraformer) export manifests with multiple AI agents.

This is the code for [this](https://blog.zacharyloeber.com/article/cagent-terraformer-rewrite/) blog entry. See it for further information on choices/logic/lessons.

## Installing

A handful of tools are needed to make this work properly. You can install them all with [mise](https://mise.jdx.dev) which can be installed for your user account using the included `./configure.sh` script. 

> **NOTE:** I do recommend you read the install script over to understand what you are doing. I also highly recommend configuring mise in your user shell for automated activation in folder that include the mise.toml configuration files. Otherwise you can run `mise en` to enable it on-demand.

While this does use docker's `cagent` tool it does not use any docker images so technically docker itself is not required.

You will need a target LLM but can use a free model from openrouter.ai or even a local ollama instance. You will need to have the `OPENAI_API_KEY` environment variable set for either of these options. You can initialize a local environment variable for this with the included task: `task secrets`. Then modify the `.env` file with an openrouter API key (or leave it as-is for ollama).

## Usage

See my blog entry on how to use this further, the gist is to use terraformer to create a json export of targeted resources in the `./input` folder then run `cagent run ./agents/terraform-cleanup.yaml` and type in something like `start` at the application console to get it to kick off.

## LLM Model Selection

I've left a local LLM model in the cagent manifest that points to a local ollama model simply to show how it is done (and that it is supported). But the local model tools use are really quite subpar to the frontier ones. As such, I've set the default model to be one of the larger free [openrouter.ai models](https://openrouter.ai/models?order=pricing-low-to-high). You will have to supply your own `OPENAI_API_KEY` environment variable for using this free resource as described above.

## Customizations

My use case was targeting the AWS provider specifically. As such I used some specific id examples for the `connecter` sub-agent in order to give it a better chance at creating the implicit dependencies between resources as I felt it was likely going to be the toughest part of the job. You can easily update the yaml for your use case and provider though.

## Resources

- [terraformer](https://github.com/GoogleCloudPlatform/terraformer)

- [cagent](https://github.com/docker/cagent)

- [terraform-mcp-server](https://github.com/hashicorp/terraform-mcp-server)

- [blog article](https://blog.zacharyloeber.com/article/cagent-terraformer-rewrite/)
