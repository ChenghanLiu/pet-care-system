<template>
  <div class="page-wrap">
    <div class="section-head">
      <div>
        <div class="section-title">农业信息列表</div>
        <div class="section-desc">按作物类型、专题分类和关键词快速检索平台已发布的农业信息条目。</div>
      </div>
    </div>
    <div class="card filter-card">
      <el-input v-model="query.keyword" placeholder="按标题或关键词搜索农业信息" clearable style="width:260px" @change="applyFilters" />
      <el-select v-model="query.categoryId" placeholder="一级分类" clearable style="width:180px" @change="onCategoryChange">
        <el-option v-for="c in categories" :key="c.id" :label="c.name" :value="c.id" />
      </el-select>
      <el-select v-model="query.subcategoryId" placeholder="二级分类" clearable style="width:180px" @change="applyFilters">
        <el-option v-for="s in subcategories" :key="s.id" :label="s.name" :value="s.id" />
      </el-select>
      <el-button type="primary" @click="applyFilters">筛选查询</el-button>
    </div>

    <el-alert v-if="loadError" :title="loadError" type="warning" :closable="false" style="margin-top: 20px;" />

    <el-row v-loading="loading" :gutter="18" style="margin-top: 20px;">
      <el-col v-for="item in list" :key="item.id" :xs="24" :sm="12" :md="8" :lg="6">
        <ProductCard :product="item" />
        <div class="item-ops">
          <el-button size="small" plain :type="favoriteIds.has(item.id) ? 'success' : undefined" @click="toggleFavorite(item.id)">
            {{ favoriteIds.has(item.id) ? '取消关注' : '关注动态' }}
          </el-button>
        </div>
      </el-col>
    </el-row>

    <div class="card empty-wrap" v-if="!list.length">
      <el-empty description="暂无符合条件的农业信息" />
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getProducts, getCategories, getSubcategories } from '../api/product'
import { addFavorite, getFavorites, removeFavorite } from '../api/favorite'
import ProductCard from '../components/ProductCard.vue'

const query = ref({ keyword: '', categoryId: undefined, subcategoryId: undefined })
const router = useRouter()
const route = useRoute()
const list = ref([])
const loading = ref(false)
const loadError = ref('')
const categories = ref([])
const subcategories = ref([])
const favoriteIds = ref(new Set())

const applyFilters = async () => {
  await router.replace({
    query: {
      keyword: query.value.keyword || undefined,
      categoryId: query.value.categoryId || undefined,
      subcategoryId: query.value.subcategoryId || undefined
    }
  })
}

const applyRouteQuery = async () => {
  query.value.keyword = typeof route.query.keyword === 'string' ? route.query.keyword : ''
  query.value.categoryId = route.query.categoryId ? Number(route.query.categoryId) : undefined
  query.value.subcategoryId = route.query.subcategoryId ? Number(route.query.subcategoryId) : undefined
  subcategories.value = await getSubcategories({ categoryId: query.value.categoryId }).catch(() => [])
}

const load = async () => {
  loading.value = true
  loadError.value = ''
  const params = {
    keyword: query.value.keyword || undefined,
    categoryId: query.value.categoryId,
    subcategoryId: query.value.subcategoryId
  }
  try {
    const data = await getProducts(params)
    list.value = Array.isArray(data) ? data : []
  } catch {
    list.value = []
    loadError.value = '农业信息加载失败，请稍后重试。'
  } finally {
    loading.value = false
  }
}

const onCategoryChange = async () => {
  query.value.subcategoryId = undefined
  subcategories.value = await getSubcategories({ categoryId: query.value.categoryId }).catch(() => [])
  await applyFilters()
}

const loadFavorites = async () => {
  try {
    const data = await getFavorites()
    favoriteIds.value = new Set((Array.isArray(data) ? data : []).map((i) => i.productId))
  } catch {
    favoriteIds.value = new Set()
  }
}

const toggleFavorite = async (productId) => {
  try {
    if (favoriteIds.value.has(productId)) {
      await removeFavorite(productId)
      favoriteIds.value.delete(productId)
    } else {
      await addFavorite(productId)
      favoriteIds.value.add(productId)
    }
    favoriteIds.value = new Set(favoriteIds.value)
  } catch (e) {
    if (e?.status === 401) {
      ElMessage.warning('请先登录后再关注信息')
      router.push(`/login?redirect=${encodeURIComponent(route.fullPath)}`)
      return
    }
    ElMessage.error('关注操作失败，请稍后重试')
  }
}

onMounted(async () => {
  categories.value = await getCategories().catch(() => [])
  await applyRouteQuery()
  await Promise.all([load(), loadFavorites()])
})

watch(
  () => route.query,
  async () => {
    await applyRouteQuery()
    await load()
  }
)
</script>

<style scoped>
.section-head {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 16px;
}

.section-desc {
  color: var(--text-secondary);
}

.item-ops {
  margin: 8px 0 18px;
}

.filter-card {
  padding: 16px;
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
}

.empty-wrap {
  margin-top: 20px;
  padding: 12px;
}
</style>
