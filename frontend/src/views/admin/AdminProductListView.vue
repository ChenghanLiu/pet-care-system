<template>
  <div class="page-wrap">
    <div class="section-title">{{ pageTitle }}</div>
    <div class="card" style="padding:16px;">
      <div class="toolbar">
        <div class="toolbar-copy">{{ pageDesc }}</div>
        <el-button type="primary" @click="openCreate">新增{{ singularTitle }}</el-button>
      </div>
      <el-table :data="products" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column label="封面" width="110">
          <template #default="{ row }">
            <el-image
              v-if="row.coverImage"
              :src="row.coverImage"
              fit="cover"
              style="width:60px;height:60px;border-radius:4px;"
            >
              <template #error>
                <div class="image-fallback">图片加载失败</div>
              </template>
            </el-image>
            <span v-else>--</span>
          </template>
        </el-table-column>
        <el-table-column prop="name" :label="nameLabel" min-width="220" />
        <el-table-column label="一级分类" min-width="120">
          <template #default="{ row }">{{ getCategoryName(row.categoryId) }}</template>
        </el-table-column>
        <el-table-column label="二级分类" min-width="140">
          <template #default="{ row }">{{ getSubcategoryName(row.subcategoryId) }}</template>
        </el-table-column>
        <el-table-column prop="price" label="参考指标" width="120">
          <template #default="{ row }">{{ Number(row.price || 0).toFixed(2) }}</template>
        </el-table-column>
        <el-table-column prop="stock" label="资源级别" width="100" />
        <el-table-column prop="sales" label="关注指数" width="100" />
        <el-table-column prop="status" label="发布状态" width="120">
          <template #default="{ row }">
            <el-switch :model-value="Number(row.status)===1" @change="(v)=>toggleStatus(row, v)" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="170">
          <template #default="{ row }">
            <el-button link type="primary" @click="openEdit(row)">编辑</el-button>
            <el-button link type="danger" @click="remove(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog v-model="visible" :title="form.id ? `编辑${singularTitle}` : `新增${singularTitle}`" width="620px">
      <el-form :model="form" label-width="96px">
        <el-form-item :label="nameLabel"><el-input v-model="form.name" /></el-form-item>
        <el-form-item label="一级分类">
          <el-select v-model="form.categoryId" style="width:100%" @change="onCategoryChange">
            <el-option v-for="item in categories" :key="item.id" :label="item.name" :value="Number(item.id)" />
          </el-select>
        </el-form-item>
        <el-form-item label="二级分类">
          <el-select v-model="form.subcategoryId" style="width:100%">
            <el-option v-for="item in subcategoriesByCategory" :key="item.id" :label="item.name" :value="Number(item.id)" />
          </el-select>
        </el-form-item>
        <el-form-item label="封面配图">
          <div class="image-upload-field">
            <el-upload
              :show-file-list="false"
              accept="image/jpeg,image/png,image/gif,image/webp"
              :http-request="uploadCoverImage"
            >
              <el-button :loading="uploading">上传封面图</el-button>
            </el-upload>
            <el-input v-model="form.coverImage" placeholder="上传后自动填写，也可手动输入图片 URL" />
          </div>
        </el-form-item>
        <el-form-item label="图片预览">
          <el-image
            v-if="form.coverImage"
            :src="form.coverImage"
            fit="cover"
            style="width:120px;height:120px;border-radius:6px;"
          >
            <template #error>
              <div class="image-fallback image-preview-fallback">图片加载失败</div>
            </template>
          </el-image>
          <div v-else class="image-fallback image-preview-fallback">请输入图片 URL</div>
        </el-form-item>
        <el-form-item label="参考指标"><el-input-number v-model="form.price" :min="0" :precision="2" /></el-form-item>
        <el-form-item label="资源级别"><el-input-number v-model="form.stock" :min="0" /></el-form-item>
        <el-form-item label="关注指数"><el-input-number v-model="form.sales" :min="0" /></el-form-item>
        <el-form-item label="内容简介"><el-input v-model="form.description" type="textarea" :rows="3" /></el-form-item>
        <el-form-item label="发布状态">
          <el-select v-model="form.status" style="width:100%">
            <el-option :value="1" label="发布" />
            <el-option :value="0" label="下线" />
          </el-select>
        </el-form-item>
        <el-form-item label="首页推荐">
          <el-select v-model="form.isRecommend" style="width:100%">
            <el-option :value="1" label="专题展示" />
            <el-option :value="0" label="普通展示" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="visible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="submit">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  uploadAdminImage,
  createAdminProduct,
  deleteAdminProduct,
  getAdminCategories,
  getAdminProducts,
  getAdminSubcategories,
  updateAdminProduct,
  updateAdminProductStatus
} from '../../api/admin'

const route = useRoute()
const loading = ref(false)
const products = ref([])
const categories = ref([])
const subcategories = ref([])
const visible = ref(false)
const submitting = ref(false)
const uploading = ref(false)
const form = ref({ id: null, name: '', categoryId: 1, subcategoryId: 1, coverImage: '', price: 0, stock: 0, sales: 0, description: '', status: 1, isRecommend: 0 })

const moduleType = computed(() => route.meta.moduleType || 'info')
const pageTitle = computed(() => moduleType.value === 'crop' ? '作物信息管理' : '农业信息管理')
const singularTitle = computed(() => moduleType.value === 'crop' ? '作物信息' : '农业信息')
const pageDesc = computed(() => moduleType.value === 'crop'
  ? '维护重点作物资料、农业指标、封面配图与发布状态，适合作为后台演示主界面。'
  : '维护农业信息条目、分类归属、说明内容与首页专题展示，不调整底层数据结构。')
const nameLabel = computed(() => moduleType.value === 'crop' ? '作物名称' : '信息标题')

const subcategoriesByCategory = computed(() => {
  return subcategories.value.filter((item) => Number(item.categoryId) === Number(form.value.categoryId))
})

const getCategoryName = (id) => {
  const category = categories.value.find((item) => Number(item.id) === Number(id))
  return category ? category.name : id
}

const getSubcategoryName = (id) => {
  const subcategory = subcategories.value.find((item) => Number(item.id) === Number(id))
  return subcategory ? subcategory.name : id
}

const load = async () => {
  loading.value = true
  try {
    const [productList, categoryList, subcategoryList] = await Promise.all([
      getAdminProducts(),
      getAdminCategories(),
      getAdminSubcategories()
    ])
    products.value = productList
    categories.value = categoryList
    subcategories.value = subcategoryList
  } finally {
    loading.value = false
  }
}

const onCategoryChange = () => {
  const first = subcategoriesByCategory.value[0]
  if (!first || Number(first.id) === Number(form.value.subcategoryId)) {
    return
  }
  form.value.subcategoryId = Number(first.id)
}

const openCreate = () => {
  const defaultCategoryId = categories.value[0] ? Number(categories.value[0].id) : 1
  const firstSub = subcategories.value.find((item) => Number(item.categoryId) === defaultCategoryId)
  form.value = {
    id: null,
    name: '',
    categoryId: defaultCategoryId,
    subcategoryId: firstSub ? Number(firstSub.id) : 1,
    coverImage: '',
    price: 0,
    stock: 0,
    sales: 0,
    description: '',
    status: 1,
    isRecommend: 0
  }
  visible.value = true
}

const openEdit = (row) => {
  form.value = {
    id: row.id,
    name: row.name || '',
    categoryId: Number(row.categoryId || 1),
    subcategoryId: Number(row.subcategoryId || 1),
    coverImage: row.coverImage || '',
    price: Number(row.price || 0),
    stock: Number(row.stock || 0),
    sales: Number(row.sales || 0),
    description: row.description || '',
    status: Number(row.status || 0),
    isRecommend: Number(row.isRecommend || 0)
  }
  if (!subcategoriesByCategory.value.some((item) => Number(item.id) === Number(form.value.subcategoryId))) {
    onCategoryChange()
  }
  visible.value = true
}

const uploadCoverImage = async ({ file }) => {
  uploading.value = true
  try {
    const result = await uploadAdminImage(file)
    form.value.coverImage = result.url
    ElMessage.success('封面图上传成功')
  } finally {
    uploading.value = false
  }
}

const submit = async () => {
  if (!form.value.name.trim()) {
    ElMessage.warning(`请输入${nameLabel.value}`)
    return
  }
  if (!form.value.categoryId || !form.value.subcategoryId) {
    ElMessage.warning('请选择农业信息所属分类')
    return
  }

  const payload = {
    name: form.value.name.trim(),
    categoryId: form.value.categoryId,
    subcategoryId: form.value.subcategoryId,
    coverImage: form.value.coverImage,
    price: form.value.price,
    stock: form.value.stock,
    sales: Number(form.value.sales || 0),
    description: form.value.description,
    status: form.value.status,
    isRecommend: form.value.isRecommend
  }

  submitting.value = true
  try {
    if (form.value.id) {
      await updateAdminProduct(form.value.id, payload)
      ElMessage.success(`${singularTitle.value}已更新`)
    } else {
      await createAdminProduct(payload)
      ElMessage.success(`${singularTitle.value}已新增`)
    }
    visible.value = false
    await load()
  } finally {
    submitting.value = false
  }
}

const toggleStatus = async (row, checked) => {
  await updateAdminProductStatus(row.id, checked ? 1 : 0)
  ElMessage.success('状态已更新')
  await load()
}

const remove = async (id) => {
  await ElMessageBox.confirm(`确认删除该${singularTitle.value}吗？`, '提示', { type: 'warning' })
  await deleteAdminProduct(id)
  ElMessage.success(`${singularTitle.value}已删除`)
  await load()
}

onMounted(load)
</script>

<style scoped>
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.toolbar-copy {
  color: var(--text-secondary);
}

.image-fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  font-size: 12px;
  color: #909399;
  background: #f5f7fa;
  text-align: center;
  padding: 4px;
  box-sizing: border-box;
}

.image-preview-fallback {
  width: 120px;
  height: 120px;
  border-radius: 6px;
}

.image-upload-field {
  display: flex;
  width: 100%;
  gap: 12px;
  align-items: center;
}

.image-upload-field :deep(.el-upload) {
  display: inline-flex;
}
</style>
