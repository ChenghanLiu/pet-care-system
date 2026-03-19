<template>
  <div class="page-wrap" v-loading="loading">
    <div v-if="loadError" class="card state-card">
      <el-result icon="warning" title="信息加载失败" :sub-title="loadError">
        <template #extra>
          <el-button type="primary" @click="$router.push('/info')">返回列表</el-button>
        </template>
      </el-result>
    </div>

    <div v-else-if="product">
      <div class="card detail-wrap">
        <img :src="imageSrc" class="detail-cover" alt="农业信息封面" @error="handleImageError" />
        <div class="detail-main">
          <div class="info-tag">农业信息档案</div>
          <h2>{{ product.name || `农业信息 #${product.id}` }}</h2>
          <div class="meta-grid">
            <div class="meta-item">
              <span>一级分类</span>
              <strong>{{ categoryName }}</strong>
            </div>
            <div class="meta-item">
              <span>二级分类</span>
              <strong>{{ subcategoryName }}</strong>
            </div>
            <div class="meta-item">
              <span>关注指数</span>
              <strong>{{ product.sales || 0 }}</strong>
            </div>
            <div class="meta-item">
              <span>参考指标</span>
              <strong>{{ Number(product.price || 0).toFixed(2) }}</strong>
            </div>
          </div>

          <div class="section-grid">
            <div class="info-panel">
              <div class="panel-title">作物概览</div>
              <p>{{ overviewText }}</p>
            </div>
            <div class="info-panel soft-panel">
              <div class="panel-title">种植区域</div>
              <p>{{ plantingRegionText }}</p>
            </div>
            <div class="info-panel soft-panel">
              <div class="panel-title">生长周期</div>
              <p>{{ growthCycleText }}</p>
            </div>
            <div class="info-panel soft-panel">
              <div class="panel-title">适宜季节</div>
              <p>{{ seasonText }}</p>
            </div>
          </div>

          <div class="narrative-block">
            <div class="panel-title">内容说明</div>
            <p class="desc">{{ product.description || '当前条目主要用于展示农业主题、分类结构与基础指标信息。' }}</p>
            <div class="micro-metrics">
                <span>资源级别：{{ reserveLevelText }}</span>
                <span>分类专题：{{ categoryName }} / {{ subcategoryName }}</span>
                <span>建议用途：用于首页展示、信息检索与后台维护演示</span>
            </div>
          </div>

          <div class="ops">
            <el-button type="primary" @click="$router.push('/announcements')">查看系统公告</el-button>
            <el-button plain :type="isFavorite ? 'success' : undefined" @click="toggleFavorite">
              {{ isFavorite ? '已关注该信息' : '关注此条信息' }}
            </el-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getCategories, getProductDetail, getSubcategories } from '../api/product'
import { addFavorite, getFavorites, removeFavorite } from '../api/favorite'

const route = useRoute()
const router = useRouter()
const product = ref(null)
const loading = ref(false)
const loadError = ref('')
const fallback = '/images/agri-placeholder.png?v=phase8'
const imageSrc = ref(fallback)
const isFavorite = ref(false)
const categoryName = ref('-')
const subcategoryName = ref('-')

const reserveLevelText = computed(() => {
  const stock = Number(product.value?.stock || 0)
  if (stock >= 200) return `资源储备充足（${stock}）`
  if (stock >= 50) return `资源储备稳定（${stock}）`
  if (stock > 0) return `资源储备偏紧（${stock}）`
  return '暂无储备数据'
})

const overviewText = computed(() => {
  const name = product.value?.name || '当前农业信息'
  return `${name} 归档于 ${categoryName.value} / ${subcategoryName.value} 专题，适合展示作物管理重点、阶段任务和农业信息系统中的结构化内容。`
})

const plantingRegionText = computed(() => {
  const regionMap = {
    粮食作物: '建议结合平原主产区、灌区条件和土壤肥力情况进行区域化管理，突出播种密度与田间整齐度。',
    经济作物: '建议结合丘陵茶园、特色经济作物示范区和坡地水肥条件进行展示，突出精细管护节点。',
    果蔬作物: '建议结合果园、棚室和近郊蔬菜基地等场景进行区域化说明，突出温湿度与采收组织。',
    农业技术: '适合结合监测点位、设备布设和巡田服务范围进行说明，突出技术支撑与信息联动。'
  }
  return regionMap[categoryName.value] || `当前条目归属 ${categoryName.value} / ${subcategoryName.value} 专题，建议结合当地土壤条件、温度区间与灌溉条件进行区域化管理和展示。`
})

const growthCycleText = computed(() => {
  const attention = Number(product.value?.sales || 0)
  const stageMap = {
    水稻种植: '可围绕育秧、分蘖、抽穗灌浆三个阶段组织展示，便于说明稻田管理和产量形成过程。',
    玉米种植: '可围绕苗期、大喇叭口期和灌浆成熟期组织展示，便于体现追肥与抗逆管理节点。',
    小麦种植: '可围绕返青、拔节、灌浆成熟期组织展示，适合呈现阶段性田间观察记录。',
    大豆种植: '可围绕苗期、开花结荚和鼓粒成熟期组织展示，体现水分管理与群体调控。',
    设施蔬菜: '可围绕育苗、定植、坐果采收三个阶段组织展示，突出棚室环境调控和茬口安排。',
    葡萄种植: '可围绕萌芽展叶、花果管理和成熟采收阶段组织展示，体现果园精细化管护。',
    柑橘果园: '可围绕花期、稳果期和膨果转色期组织展示，便于说明保花保果和树势调控。',
    苹果梨类: '可围绕花前准备、幼果管理和采收着色期组织展示，突出修剪和品质提升。',
    茶叶产业: '可围绕萌芽、采摘和采后轻修剪阶段组织展示，体现茶园季节性管理。'
  }
  return `${stageMap[subcategoryName.value] || '可按播种准备、苗期管理、中后期监测三个阶段理解该条目。'} 当前关注指数为 ${attention}，适合在演示中呈现持续跟踪类农业资料。`
})

const seasonText = computed(() => {
  const seasonMap = {
    粮食作物: '以春播和秋收阶段为重点，适合结合墒情与田间管理进行说明。',
    经济作物: '适宜在春夏生长旺季重点展示，同时关注采收期与病虫害防控。',
    果蔬作物: '建议按春秋两季为主线展示，突出温度、水肥和设施管理要点。',
    农业技术: '适合围绕年度生产周期组织内容，突出监测、预警与技术服务节点。'
  }
  return seasonMap[categoryName.value] || '建议结合当地气候条件，在春季播种准备与秋季采收管理阶段重点参考。'
})

const handleImageError = (event) => {
  if (imageSrc.value === fallback) return
  imageSrc.value = fallback
  event.target.src = fallback
}

const loadFavoriteState = async () => {
  try {
    const list = await getFavorites()
    isFavorite.value = (Array.isArray(list) ? list : []).some((i) => i.productId === Number(product.value?.id))
  } catch {
    isFavorite.value = false
  }
}

const toggleFavorite = async () => {
  if (!product.value?.id) return
  try {
    if (!isFavorite.value) {
      await addFavorite(product.value.id)
      isFavorite.value = true
      ElMessage.success('关注成功')
    } else {
      await removeFavorite(product.value.id)
      isFavorite.value = false
      ElMessage.success('已取消关注')
    }
  } catch (e) {
    if (e?.status === 401) {
      ElMessage.warning('请先登录后再关注')
      router.push(`/login?redirect=${encodeURIComponent(route.fullPath)}`)
      return
    }
    ElMessage.error('关注操作失败，请稍后重试')
  }
}

onMounted(async () => {
  loading.value = true
  loadError.value = ''
  try {
    const id = route.params.id
    product.value = await getProductDetail(id)
    imageSrc.value = product.value?.coverImage || fallback
    const [categories, subcategories] = await Promise.all([
      getCategories().catch(() => []),
      getSubcategories({ categoryId: product.value?.categoryId }).catch(() => [])
    ])
    categoryName.value = categories.find((item) => Number(item.id) === Number(product.value?.categoryId))?.name || '-'
    subcategoryName.value = subcategories.find((item) => Number(item.id) === Number(product.value?.subcategoryId))?.name || '-'
    await loadFavoriteState()
  } catch (error) {
    product.value = null
    imageSrc.value = fallback
    loadError.value = error?.status === 404 ? '该农业信息不存在或已下线。' : '当前农业信息暂时无法查看，请稍后重试。'
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.detail-wrap {
  display: grid;
  grid-template-columns: 420px 1fr;
  gap: 28px;
  padding: 22px;
}

.state-card {
  padding: 24px;
}

.detail-cover {
  width: 100%;
  height: 360px;
  object-fit: cover;
  border-radius: 12px;
}

.info-tag {
  display: inline-flex;
  padding: 7px 12px;
  border-radius: 999px;
  background: #edf5e7;
  color: var(--brand-deep);
  font-size: 12px;
  letter-spacing: 0.08em;
}

.meta-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
  margin-top: 18px;
}

.meta-item {
  padding: 14px;
  border-radius: 12px;
  background: #f6f8ef;
}

.meta-item span {
  display: block;
  margin-bottom: 8px;
  color: var(--text-secondary);
  font-size: 13px;
}

.meta-item strong {
  color: var(--brand-deep);
  font-size: 18px;
}

.info-panel {
  padding: 18px;
  border-radius: 12px;
  background: linear-gradient(135deg, rgba(111, 170, 91, 0.12), rgba(211, 167, 79, 0.14));
}

.section-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
  margin-top: 18px;
}

.soft-panel {
  background: #f7f8f1;
}

.panel-title {
  font-weight: 700;
  color: var(--brand-deep);
}

.desc {
  margin-top: 12px;
  color: var(--text-secondary);
  line-height: 1.8;
}

.info-panel p,
.narrative-block p {
  margin: 10px 0 0;
  color: var(--text-secondary);
  line-height: 1.8;
}

.narrative-block {
  margin-top: 18px;
  padding: 18px;
  border-radius: 12px;
  border: 1px solid rgba(111, 170, 91, 0.18);
  background: #fffdf7;
}

.micro-metrics {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 14px;
}

.micro-metrics span {
  padding: 8px 12px;
  border-radius: 999px;
  background: #f3f6ea;
  color: var(--brand-deep);
  font-size: 13px;
}

.ops {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 18px;
}

@media (max-width: 900px) {
  .detail-wrap {
    grid-template-columns: 1fr;
  }

  .section-grid {
    grid-template-columns: 1fr;
  }
}
</style>
