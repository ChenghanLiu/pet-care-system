<template>
  <div class="page-wrap" v-loading="loading">
    <div v-if="loadError" class="card state-card">
      <el-result icon="warning" title="宠物档案加载失败" :sub-title="loadError">
        <template #extra>
          <el-button type="primary" @click="$router.push('/info')">返回列表</el-button>
        </template>
      </el-result>
    </div>

    <div v-else-if="product">
      <div class="card detail-wrap">
        <img :src="imageSrc" class="detail-cover" alt="宠物信息封面" @error="handleImageError" />
        <div class="detail-main">
          <div class="info-tag">宠物关怀档案</div>
          <h2>{{ product.name || `宠物档案 #${product.id}` }}</h2>
          <div class="meta-grid">
            <div class="meta-item">
              <span>宠物大类</span>
              <strong>{{ categoryName }}</strong>
            </div>
            <div class="meta-item">
              <span>细分标签</span>
              <strong>{{ subcategoryName }}</strong>
            </div>
            <div class="meta-item">
              <span>关注热度</span>
              <strong>{{ product.sales || 0 }}</strong>
            </div>
            <div class="meta-item">
              <span>亲和指数</span>
              <strong>{{ Number(product.price || 0).toFixed(2) }}</strong>
            </div>
          </div>

          <div class="section-grid">
            <div class="info-panel">
              <div class="panel-title">宠物概览</div>
              <p>{{ overviewText }}</p>
            </div>
            <div class="info-panel soft-panel">
              <div class="panel-title">性格特点</div>
              <p>{{ personalityText }}</p>
            </div>
            <div class="info-panel soft-panel">
              <div class="panel-title">照护建议</div>
              <p>{{ careGuideText }}</p>
            </div>
            <div class="info-panel soft-panel">
              <div class="panel-title">适合家庭</div>
              <p>{{ familyFitText }}</p>
            </div>
          </div>

          <div class="narrative-block">
            <div class="panel-title">档案说明</div>
            <p class="desc">{{ product.description || '当前条目主要用于展示宠物档案、分类结构与基础照护信息。' }}</p>
            <div class="micro-metrics">
              <span>关注状态：{{ reserveLevelText }}</span>
              <span>分类标签：{{ categoryName }} / {{ subcategoryName }}</span>
              <span>展示建议：适合首页推荐、档案检索与后台维护演示</span>
            </div>
          </div>

          <div class="ops">
            <el-button type="primary" @click="$router.push('/announcements')">查看爱心公告</el-button>
            <el-button plain :type="isFavorite ? 'success' : undefined" @click="toggleFavorite">
              {{ isFavorite ? '已关注该宠物' : '关注这只萌宠' }}
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
const fallback = '/images/pet-cat-orange.png?v=pet-shell'
const imageSrc = ref(fallback)
const isFavorite = ref(false)
const categoryName = ref('-')
const subcategoryName = ref('-')

const reserveLevelText = computed(() => {
  const stock = Number(product.value?.stock || 0)
  if (stock >= 200) return `可优先推荐（${stock}）`
  if (stock >= 50) return `状态稳定（${stock}）`
  if (stock > 0) return `建议尽快跟进（${stock}）`
  return '暂无安置数据'
})

const overviewText = computed(() => {
  const name = product.value?.name || '当前宠物档案'
  return `${name} 归档于 ${categoryName.value} / ${subcategoryName.value} 分类，适合查看宠物基础信息、照护建议和陪伴特点。`
})

const personalityText = computed(() => {
  const personalityMap = {
    狗狗: '多数性格外向忠诚，适合强调互动性、陪伴感和日常运动需求。',
    猫咪: '多数独立温柔，适合突出安静陪伴、居家适应与情绪疗愈体验。',
    兔兔: '整体气质安静细腻，适合呈现轻陪伴和规律照护的日常节奏。',
    鸟类: '互动方式灵活，鸣叫和站杆训练都有趣味，适合喜欢观察交流的用户。'
  }
  return personalityMap[categoryName.value] || `当前条目归属 ${categoryName.value} / ${subcategoryName.value} 分类，可结合性格特点、互动方式与陪伴价值进行了解。`
})

const careGuideText = computed(() => {
  const attention = Number(product.value?.sales || 0)
  const stageMap = {
    金毛: '建议围绕日常遛弯、情绪陪伴和定期梳毛进行说明，突出其亲和稳定的家庭属性。',
    柯基: '适合说明居家陪伴、轻运动和臀腿护理要点，突出小体型犬的管理场景。',
    亲人: '可强调其愿意靠近人的互动特征，方便用户判断是否适合高频陪伴。',
    布偶: '适合突出温和互动、毛发护理和稳定情绪，方便了解其居家陪伴特点。',
    英国短毛猫: '适合说明居家安置、梳毛陪玩和环境管理等日常照护内容。',
    幼年: '可围绕作息建立、精力释放和健康观察进行介绍，体现成长阶段特点。',
    垂耳兔: '可说明草料喂养、安静环境和清洁频次，突出轻陪伴型宠物特征。',
    已登记: '可重点查看其健康记录、饮食习惯和适应情况，方便后续持续关注。',
    温顺: '适合说明抱持配合度和日常互动节奏，帮助用户建立稳定照护预期。',
    虎皮鹦鹉: '可围绕站杆互动、鸣叫节奏和环境通风展开，体现鸟类日常特点。',
    玄凤鹦鹉: '适合说明手喂训练、熟人识别和情绪稳定性，便于理解互动方式。',
    活泼: '可强调其活动量、探索欲和固定互动时间的重要性。'
  }
  return `${stageMap[subcategoryName.value] || '可从饮食、互动和健康观察三个方面理解该条目。'} 当前人气值为 ${attention}，适合持续关注其日常状态与陪伴需求。`
})

const familyFitText = computed(() => {
  const familyMap = {
    狗狗: '适合有陪伴时间、愿意日常外出活动的家庭，能够体现宠物互动价值。',
    猫咪: '适合追求安静居家陪伴和疗愈氛围的用户，整体相处节奏更轻松自然。',
    兔兔: '适合空间较安静、愿意规律清洁和观察饮食状态的家庭。',
    鸟类: '适合关注互动频率、通风环境和日常作息的家庭，便于建立稳定陪伴。'
  }
  return familyMap[categoryName.value] || '适合结合用户需求、空间条件与照护时间进行说明。'
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
      ElMessage.warning('请先登录后再关注宠物')
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
    loadError.value = error?.status === 404 ? '该宠物档案不存在或已下线。' : '当前宠物档案暂时无法查看，请稍后重试。'
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
  background: rgba(255, 138, 101, 0.12);
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
  background: #fff8f2;
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
  background: linear-gradient(135deg, rgba(255, 138, 101, 0.12), rgba(243, 191, 120, 0.18));
}

.section-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
  margin-top: 18px;
}

.soft-panel {
  background: #fffdf9;
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
  border: 1px solid rgba(239, 127, 87, 0.14);
  background: #fffdf9;
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
  background: rgba(255, 138, 101, 0.1);
  color: var(--brand-deep);
  font-size: 13px;
}

.ops {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 18px;
}

@media (max-width: 960px) {
  .detail-wrap,
  .section-grid {
    grid-template-columns: 1fr;
  }
}
</style>
