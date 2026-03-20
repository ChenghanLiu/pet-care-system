<template>
  <div class="page-wrap">
    <div class="section-head">
      <div>
        <div class="section-title">我的关注萌宠</div>
        <div class="section-desc">集中查看你已关注的宠物档案，可继续浏览详情或随时取消关注。</div>
      </div>
      <el-button plain @click="$router.push('/info')">继续浏览萌宠档案</el-button>
    </div>
    <el-alert v-if="loadError" :title="loadError" type="warning" :closable="false" style="margin-top: 16px;" />
    <div class="card" style="padding:16px; margin-top: 16px;" v-loading="loading">
      <el-empty v-if="!loading && !products.length" description="你暂时还没有关注萌宠，可前往档案列表查看并收藏心仪毛孩子。">
        <el-button type="primary" @click="$router.push('/info')">前往宠物档案列表</el-button>
      </el-empty>
      <el-row v-else :gutter="18">
        <el-col v-for="item in products" :key="item.id" :xs="24" :sm="12" :md="8" :lg="6">
          <ProductCard :product="item" />
          <div class="ops">
            <el-button size="small" type="danger" plain @click.stop="unfavorite(item.id)">取消关注</el-button>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import ProductCard from '../components/ProductCard.vue'
import { getFavorites, removeFavorite } from '../api/favorite'
import { getProductDetail } from '../api/product'

const products = ref([])
const loading = ref(false)
const loadError = ref('')

const load = async () => {
  loading.value = true
  loadError.value = ''
  try {
    const list = await getFavorites()
    const ids = (Array.isArray(list) ? list : []).map((i) => i.productId)
    const details = await Promise.all(ids.map(async (id) => {
      try {
        return await getProductDetail(id)
      } catch {
        return null
      }
    }))
    products.value = details.filter(Boolean)
  } catch {
    products.value = []
    loadError.value = '关注列表加载失败，请稍后重试。'
  } finally {
    loading.value = false
  }
}

const unfavorite = async (productId) => {
  try {
    await removeFavorite(productId)
    ElMessage.success('已取消关注')
    await load()
  } catch {
    ElMessage.error('取消关注失败，请稍后重试。')
  }
}

onMounted(load)
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

.ops {
  margin: 8px 0 18px;
}
</style>
