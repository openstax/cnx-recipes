export enum PLATFORMS {
  WEB = 'rex-web',
  PDF = 'PDF'
}

export var getStyleFiles: (platform: PLATFORM) => Map<string, string>
export var getStyleContents: (platform: PLATFORM) => Map<string, string>