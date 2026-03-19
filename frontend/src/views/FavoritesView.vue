<template>
  <div class="page-wrap">
    <div class="section-head">
      <div>
        <div class="section-title">我的关注信息</div>
        <div class="section-desc">集中查看你已关注的农业信息，支持继续浏览详情或取消关注。</div>
      </div>
    </div>
    <el-alert v-if="loadError" :title="loadError" type="warning" :closable="false" style="margin-top: 16px;" />
    <div class="card" style="padding:16px; margin-top: 16px;" v-loading="loading">
      <el-empty v-if="!loading && !products.length" description="你暂时还没有关注农业信息，去信息列表看看吧" />
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
    loadError.value = '关注信息加载失败，请稍后重试。'
  } finally {
    loading.value = false
  }
}

const unfavorite = async (productId) => {
  await removeFavorite(productId)
  ElMessage.success('已取消关注')
  await load()
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
