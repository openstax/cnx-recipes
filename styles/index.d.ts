export enum PLATFORM {
  WEB = 'rex-web',
  PDF = 'PDF'
}

export var getStyleFiles: (platform: PLATFORM) => Promise<Map<string, string>>
export var getStyleContents: (platform: PLATFORM) => Promise<Map<string, string>>