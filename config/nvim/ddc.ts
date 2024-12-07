import { BaseConfig, ConfigArguments } from "jsr:@shougo/ddc-vim@9.0.0/config";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "pum",
      sources: [
        "lsp", "around"
      ],
      sourceOptions: {
        "_": {
          matchers: ["matcher_fuzzy"],
          sorters: ["sorter_fuzzy"],
        },
        "lsp": {
          mark: "[LSP]",
          forceCompletionPattern: "\.\w*|:\w*|->\w*",
        },
      },
      sourceParams: {
        "lsp": {
          enableResolveItems: true,
          enableAdditionalTextEdit: true,
        }
      }
    })
  }
}
