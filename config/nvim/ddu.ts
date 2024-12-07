import {
  BaseConfig,
  ConfigArguments
} from "jsr:@shougo/ddu-vim@7.0.0/config";
import { columns } from "jsr:@denops/std/option";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "ff",
      uiParams: {
        ff: {
          split: "floating",
          floatingBorder: "solid",
          prompt: "> ",
        }
      },
      sourceOptions: {
        "_": {
          matchers: ["matcher_substring"],
        },
      },
    });
    
    args.contextBuilder.patchLocal("files", {
      uiParams: {
        ff: {
          floatingTitle: `Files ${Deno.cwd()}`,
          previewFloating: true,
          previewFloatingBorder: "solid",
          previewFloatingTitle: "Preview",
        }
      },
      sources: [
        { name: "file_rec" }
      ],
      kindOptions: {
        file: {
          defaultAction: "open",
        }
      }
    });

    args.contextBuilder.patchLocal("lines", {
      uiParams: {
        ff: {
          floatingTitle: "Lines"
        }
      },
      sources: [
        { name: "line" }
      ],
      kindOptions: {
        file: {
          defaultAction: "open"
        }
      }
    });

  }
}
