const exactTextMap = new Map([
  ['白酒', '猫咪'],
  ['啤酒', '狗狗'],
  ['红酒', '兔兔'],
  ['洋酒', '鸟类'],
  ['酱香', '布偶'],
  ['浓香', '英国短毛猫'],
  ['清香', '幼年'],
  ['兼香', '金毛'],
  ['其他香型', '亲人'],
  ['工业啤酒', '柯基'],
  ['精酿啤酒', '垂耳兔'],
  ['进口啤酒', '已登记'],
  ['果味啤酒', '温顺'],
  ['干红', '虎皮鹦鹉'],
  ['甜红', '玄凤鹦鹉'],
  ['起泡酒', '活泼'],
  ['进口红酒', '待领养'],
  ['国产红酒', '已登记'],
  ['威士忌', '猫咪'],
  ['白兰地', '狗狗'],
  ['伏特加', '兔兔'],
  ['朗姆酒', '鸟类'],
  ['金酒', '亲人'],
  ['贵州酱香白酒 500ml', '布偶猫 团团'],
  ['经典浓香白酒 52度', '英国短毛猫 年糕'],
  ['清爽工业啤酒 330ml*24听', '金毛 可乐'],
  ['精酿IPA啤酒 500ml*12瓶', '柯基 豆包'],
  ['进口干红葡萄酒 750ml', '垂耳兔 糯米'],
  ['国产甜红葡萄酒 750ml', '玄凤鹦鹉 云朵'],
  ['苏格兰威士忌 700ml', '虎皮鹦鹉 小七'],
  ['经典白兰地 700ml', '米克斯犬 七喜'],
  ['新品精酿节', '春季领养见面日'],
  ['红酒品鉴月', '新增宠物档案通知'],
  ['洋酒礼盒专区', '热门宠物档案'],
  ['系统上线公告', '平台上线公告'],
  ['配送时效说明', '领养流程说明'],
  ['红酒基础知识', '宠物健康护理提示']
])

const partialTextMap = [
  ['酱香突出、口感醇厚，适合聚会与礼赠。', '性格亲人稳定，适合首次养宠家庭与亲子陪伴场景。'],
  ['浓香风味明显，入口绵甜，回味悠长。', '精力充沛、互动积极，适合有陪伴时间和户外活动需求的家庭。'],
  ['经典工业拉格口味，适合日常畅饮。', '作息规律、适应力强，适合作为城市家庭日常陪伴宠物。'],
  ['酒花香气浓郁，苦度平衡，精酿爱好者推荐。', '毛量丰厚、性格温和，适合希望打造治愈型陪伴体验的用户。'],
  ['果香浓郁，单宁柔顺，适合牛排与烤肉搭配。', '外形软萌、互动温顺，适合安静居家场景和轻陪伴需求。'],
  ['口感柔和偏甜，适合入门用户。', '体型小巧、观察趣味强，适合规律照护和轻量陪伴。'],
  ['经典橡木桶陈酿风味，层次丰富。', '已建立健康记录与日常观察档案，方便持续了解状态变化。'],
  ['果香与木香平衡，适合作为餐后酒。', '已登记基础信息与喂养习惯，便于后续稳定照护。'],
  ['酒水销售系统已正式上线，欢迎体验浏览。', '宠物信息平台已上线，欢迎查看宠物档案、平台公告与后台内容。'],
  ['当前内容默认24小时内更新，具体以后台操作为准。', '平台中的宠物档案与公告由后台统一维护，请以当前发布信息为准。'],
  ['入门可优先选择甜红或果香明显的干红，口感更友好。', '新手可优先关注性格稳定、护理难度较低的宠物档案，更方便建立照护节奏。']
]

const buildSvgDataUri = ({ title, subtitle, accent, start, end }) => {
  const svg = `
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 520">
      <defs>
        <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="${start}" />
          <stop offset="100%" stop-color="${end}" />
        </linearGradient>
      </defs>
      <rect width="800" height="520" rx="32" fill="url(#bg)" />
      <circle cx="660" cy="108" r="88" fill="rgba(255,255,255,0.18)" />
      <circle cx="150" cy="420" r="110" fill="rgba(255,255,255,0.12)" />
      <path d="M182 164c22-38 44-58 66-58 23 0 38 22 44 58 26-22 53-34 82-34 72 0 126 58 126 128 0 112-106 170-168 170-64 0-170-58-170-170 0-38 18-76 50-94z" fill="rgba(255,255,255,0.94)" />
      <circle cx="254" cy="254" r="8" fill="${accent}" />
      <circle cx="334" cy="254" r="8" fill="${accent}" />
      <path d="M294 294c16 18 34 18 50 0" stroke="${accent}" stroke-width="8" stroke-linecap="round" fill="none" />
      <path d="M280 214l-30-42" stroke="${accent}" stroke-width="10" stroke-linecap="round" />
      <path d="M308 214l12-48" stroke="${accent}" stroke-width="10" stroke-linecap="round" />
      <path d="M322 214l38-48" stroke="${accent}" stroke-width="10" stroke-linecap="round" />
      <rect x="84" y="66" width="150" height="38" rx="19" fill="rgba(255,255,255,0.22)" />
      <text x="106" y="92" font-size="18" fill="#fff" font-family="Arial, PingFang SC, Microsoft YaHei, sans-serif">宠物信息平台</text>
      <text x="84" y="420" font-size="52" font-weight="700" fill="#fff" font-family="Arial, PingFang SC, Microsoft YaHei, sans-serif">${title}</text>
      <text x="84" y="462" font-size="24" fill="rgba(255,255,255,0.92)" font-family="Arial, PingFang SC, Microsoft YaHei, sans-serif">${subtitle}</text>
    </svg>
  `
  return `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(svg)}`
}

const imagePresetMap = new Map([
  ['dog', buildSvgDataUri({ title: '温暖陪伴', subtitle: '展示狗狗档案与日常互动信息', accent: '#ef7f57', start: '#ffb58d', end: '#ff7d6d' })],
  ['cat', buildSvgDataUri({ title: '软萌治愈', subtitle: '展示猫咪档案与互动亮点', accent: '#b06d57', start: '#ffd8c4', end: '#f4b08e' })],
  ['small', buildSvgDataUri({ title: '轻陪伴专区', subtitle: '展示兔兔与鸟类等轻陪伴宠物', accent: '#8a5f78', start: '#f1bfd5', end: '#d990b6' })],
  ['service', buildSvgDataUri({ title: '平台公告', subtitle: '展示领养须知与护理提醒', accent: '#4c7a54', start: '#b9df97', end: '#74b96f' })],
  ['banner1', buildSvgDataUri({ title: '遇见有缘毛孩子', subtitle: '首页主视觉与宠物推荐展示', accent: '#ef7f57', start: '#ffba91', end: '#ff8e71' })],
  ['banner2', buildSvgDataUri({ title: '宠物分类清晰可查', subtitle: '支持按分类与关键词浏览宠物档案', accent: '#b06d57', start: '#ffe1cf', end: '#f6b899' })],
  ['banner3', buildSvgDataUri({ title: '发现属于你的陪伴', subtitle: '包含档案浏览 公告维护 与后台管理', accent: '#4c7a54', start: '#cae7a9', end: '#87c67b' })],
  ['placeholder', buildSvgDataUri({ title: '萌宠档案', subtitle: '等待完善封面图片', accent: '#8a5f78', start: '#f0d0dd', end: '#d7a8c0' })]
])

const assetImageMap = new Map([
  ['/images/agri-rice.svg', '/images/pet-dog-golden.png'],
  ['/images/agri-corn.svg', '/images/pet-dog-shiba.png'],
  ['/images/agri-vegetable.svg', '/images/pet-cat-orange.png'],
  ['/images/agri-tea.svg', '/images/pet-cat-ragdoll.png'],
  ['/images/agri-apple.svg', '/images/pet-rabbit-lop.png'],
  ['/images/agri-grape.svg', '/images/pet-hamster-silver.png'],
  ['/images/agri-smart.svg', '/images/pet-parrot-cockatiel.png'],
  ['/images/agri-pest.svg', '/images/pet-rabbit-lop.png'],
  ['/images/agri-placeholder.svg', '/images/pet-cat-orange.png'],
  ['/images/agri-banner-1.svg', imagePresetMap.get('banner1')],
  ['/images/agri-banner-2.svg', imagePresetMap.get('banner2')],
  ['/images/agri-banner-3.svg', imagePresetMap.get('banner3')],
  ['/images/agri-rice.png', '/images/pet-dog-golden.png'],
  ['/images/agri-corn.png', '/images/pet-dog-shiba.png'],
  ['/images/agri-vegetable.png', '/images/pet-cat-orange.png'],
  ['/images/agri-tea.png', '/images/pet-cat-ragdoll.png'],
  ['/images/agri-apple.png', '/images/pet-rabbit-lop.png'],
  ['/images/agri-grape.png', '/images/pet-hamster-silver.png'],
  ['/images/agri-smart.png', '/images/pet-parrot-cockatiel.png'],
  ['/images/agri-pest.png', '/images/pet-rabbit-lop.png'],
  ['/images/agri-placeholder.png', '/images/pet-cat-orange.png'],
  ['/images/agri-banner-1.png', imagePresetMap.get('banner1')],
  ['/images/agri-banner-2.png', imagePresetMap.get('banner2')],
  ['/images/agri-banner-3.png', imagePresetMap.get('banner3')],
  ['https://demo.wineshop.com/images/p1001.jpg', '/images/pet-dog-golden.png'],
  ['https://demo.wineshop.com/images/p1002.jpg', '/images/pet-dog-shiba.png'],
  ['https://demo.wineshop.com/images/p1003.jpg', '/images/pet-cat-orange.png'],
  ['https://demo.wineshop.com/images/p1004.jpg', '/images/pet-cat-ragdoll.png'],
  ['https://demo.wineshop.com/images/p1005.jpg', '/images/pet-rabbit-lop.png'],
  ['https://demo.wineshop.com/images/p1006.jpg', '/images/pet-hamster-silver.png'],
  ['https://demo.wineshop.com/images/p1007.jpg', '/images/pet-parrot-cockatiel.png'],
  ['https://demo.wineshop.com/images/p1008.jpg', '/images/pet-rabbit-lop.png'],
  ['https://demo.wineshop.com/images/p1001_detail_1.jpg', '/images/pet-dog-golden.png'],
  ['https://demo.wineshop.com/images/p1001_detail_2.jpg', '/images/pet-dog-shiba.png'],
  ['https://demo.wineshop.com/images/p1004_detail_1.jpg', '/images/pet-cat-ragdoll.png'],
  ['https://demo.wineshop.com/images/p1005_detail_1.jpg', '/images/pet-rabbit-lop.png'],
  ['https://demo.wineshop.com/banner/banner1.jpg', imagePresetMap.get('banner1')],
  ['https://demo.wineshop.com/banner/banner2.jpg', imagePresetMap.get('banner2')],
  ['https://demo.wineshop.com/banner/banner3.jpg', imagePresetMap.get('banner3')],
  ['https://demo.wineshop.com/activity/a1.jpg', imagePresetMap.get('banner1')],
  ['https://demo.wineshop.com/activity/a2.jpg', imagePresetMap.get('banner2')],
  ['https://demo.wineshop.com/activity/a3.jpg', imagePresetMap.get('banner3')]
])

const localPlaceholder = '/images/pet-cat-orange.png'

export const mapBusinessText = (value) => {
  const source = String(value ?? '')
  if (!source) return source
  if (exactTextMap.has(source)) return exactTextMap.get(source)
  return partialTextMap.reduce((text, [from, to]) => text.replaceAll(from, to), source)
}

export const mapImageUrl = (value) => {
  const source = String(value ?? '').trim()
  if (!source) return localPlaceholder
  if (assetImageMap.has(source)) return assetImageMap.get(source)
  if (source.includes('demo.wineshop.com')) return localPlaceholder
  return source
}

export const normalizeCategory = (item) => ({ ...item, name: mapBusinessText(item?.name) })
export const normalizeSubcategory = (item) => ({ ...item, name: mapBusinessText(item?.name) })
export const normalizeProduct = (item) => ({
  ...item,
  name: mapBusinessText(item?.name),
  description: mapBusinessText(item?.description),
  coverImage: mapImageUrl(item?.coverImage)
})
export const normalizeBanner = (item) => ({
  ...item,
  title: mapBusinessText(item?.title),
  imageUrl: mapImageUrl(item?.imageUrl),
  linkUrl: item?.linkUrl?.replace('/products', '/info')
})
export const normalizeNotice = (item) => ({
  ...item,
  title: mapBusinessText(item?.title),
  content: mapBusinessText(item?.content)
})
