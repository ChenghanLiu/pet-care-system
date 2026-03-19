import http from './http'
import { normalizeBanner, normalizeCategory, normalizeNotice, normalizeProduct, normalizeSubcategory } from '../utils/agriTransform'

const ensureList = (value) => (Array.isArray(value) ? value : [])

export const getAdminUsers = () => http.get('/api/admin/users')
export const updateAdminUser = (id, payload) => http.put(`/api/admin/users/${id}`, payload)
export const deleteAdminUser = (id) => http.delete(`/api/admin/users/${id}`)

export const getAdminProducts = async () => ensureList(await http.get('/api/admin/products')).map(normalizeProduct)
export const createAdminProduct = (payload) => http.post('/api/admin/products', payload)
export const updateAdminProduct = (id, payload) => http.put(`/api/admin/products/${id}`, payload)
export const updateAdminProductStatus = (id, status) => http.put(`/api/admin/products/${id}/status`, null, { params: { status } })
export const deleteAdminProduct = (id) => http.delete(`/api/admin/products/${id}`)


export const getAdminCategories = async () => ensureList(await http.get('/api/admin/categories')).map(normalizeCategory)
export const createAdminCategory = (payload) => http.post('/api/admin/categories', payload)
export const updateAdminCategory = (id, payload) => http.put(`/api/admin/categories/${id}`, payload)
export const deleteAdminCategory = (id) => http.delete(`/api/admin/categories/${id}`)

export const getAdminSubcategories = async () => ensureList(await http.get('/api/admin/subcategories')).map(normalizeSubcategory)
export const createAdminSubcategory = (payload) => http.post('/api/admin/subcategories', payload)
export const updateAdminSubcategory = (id, payload) => http.put(`/api/admin/subcategories/${id}`, payload)
export const deleteAdminSubcategory = (id) => http.delete(`/api/admin/subcategories/${id}`)

export const getAdminOrders = (params) => http.get('/api/admin/orders', { params })
export const deliverAdminOrder = (id) => http.post(`/api/admin/orders/${id}/deliver`)
export const refundAdminOrder = (id) => http.post(`/api/admin/orders/${id}/refund`)

export const getAdminBanners = async () => ensureList(await http.get('/api/admin/banners')).map(normalizeBanner)
export const createAdminBanner = (payload) => http.post('/api/admin/banners', payload)
export const updateAdminBanner = (id, payload) => http.put(`/api/admin/banners/${id}`, payload)
export const deleteAdminBanner = (id) => http.delete(`/api/admin/banners/${id}`)
export const uploadAdminImage = (file) => {
  const formData = new FormData()
  formData.append('file', file)
  return http.post('/api/admin/upload/image', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export const getAdminNotices = async () => ensureList(await http.get('/api/admin/notices')).map(normalizeNotice)
export const createAdminNotice = (payload) => http.post('/api/admin/notices', payload)
export const updateAdminNotice = (id, payload) => http.put(`/api/admin/notices/${id}`, payload)
export const deleteAdminNotice = (id) => http.delete(`/api/admin/notices/${id}`)

export const getAdminComments = () => http.get('/api/admin/comments')
export const updateAdminCommentStatus = (id, status) => http.put(`/api/admin/comments/${id}/status`, null, { params: { status } })
export const deleteAdminComment = (id) => http.delete(`/api/admin/comments/${id}`)

export const getAdminOverview = () => http.get('/api/admin/statistics/overview')
export const getAdminTopProducts = () => http.get('/api/admin/statistics/top-products')
export const getAdminCategoryRatio = () => http.get('/api/admin/statistics/category-ratio')
