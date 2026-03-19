import http from './http'
import { normalizeCategory, normalizeProduct, normalizeSubcategory } from '../utils/agriTransform'

const ensureList = (value) => (Array.isArray(value) ? value : [])

export const getRecommendProducts = async () => ensureList(await http.get('/api/products/recommend')).map(normalizeProduct)
export const getProducts = async (params) => ensureList(await http.get('/api/products', { params })).map(normalizeProduct)
export const getProductDetail = async (id) => normalizeProduct(await http.get(`/api/products/${id}`))
export const getProductComments = (id) => http.get(`/api/products/${id}/comments`)
export const getCategories = async () => ensureList(await http.get('/api/categories')).map(normalizeCategory)
export const getCategoryTree = () => http.get('/api/categories/tree')
export const getSubcategories = async (params) => ensureList(await http.get('/api/subcategories', { params })).map(normalizeSubcategory)
