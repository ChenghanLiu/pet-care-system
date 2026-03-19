import http from './http'
import { normalizeBanner, normalizeNotice } from '../utils/agriTransform'

const ensureList = (value) => (Array.isArray(value) ? value : [])

export const getPublicBanners = async () => ensureList(await http.get('/api/banners')).map(normalizeBanner)
export const getPublicNotices = async () => ensureList(await http.get('/api/notices')).map(normalizeNotice)
