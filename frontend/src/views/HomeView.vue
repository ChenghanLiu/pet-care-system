<template>
  <div class="page-wrap">
    <section class="hero">
      <div class="hero-main card">
        <el-carousel height="340px" indicator-position="outside">
          <el-carousel-item v-for="item in slides" :key="item.title">
            <div class="slide" :style="{ backgroundImage: `url(${item.imageUrl})` }" role="button" tabindex="0" @click="openBannerTarget(item)" @keyup.enter="openBannerTarget(item)">
              <div class="overlay">
                <div class="eyebrow">宠物信息平台</div>
                <h1>{{ item.title }}</h1>
                <p>{{ item.summary }}</p>
                <div class="hero-actions">
                  <el-button type="primary" @click="$router.push('/info')">查看宠物信息</el-button>
                  <el-button plain @click="$router.push('/announcements')">浏览爱心公告</el-button>
                </div>
              </div>
            </div>
          </el-carousel-item>
        </el-carousel>
      </div>
      <div class="hero-side card">
        <div class="side-title">萌宠分类导航</div>
        <template v-if="categories.length">
          <router-link
            v-for="category in categories"
            :key="category.id"
            class="category-link"
            :to="`/info?categoryId=${category.id}`"
          >
            <span>{{ category.name || `宠物分类 #${category.id}` }}</span>
            <span>进入专区</span>
          </router-link>
        </template>
        <el-empty v-else description="暂无宠物分类" />
      </div>
    </section>

    <section class="section-block">
      <div class="section-title">推荐萌宠档案</div>
      <div class="section-desc">集中展示热门宠物档案、分类信息和平台公告，方便用户快速浏览近期关注内容。</div>
      <el-row :gutter="18" style="margin-top: 18px;">
        <el-col v-for="item in recommendList" :key="item.id" :xs="24" :sm="12" :md="8" :lg="6">
          <ProductCard :product="item" />
        </el-col>
      </el-row>
    </section>

    <section class="section-block content-grid">
      <div class="card notice-panel">
        <div class="panel-head">
          <div class="section-title panel-title">最新爱心动态</div>
          <router-link class="more-link" to="/announcements">查看全部</router-link>
        </div>
        <div v-if="notices.length" class="notice-list">
          <article v-for="item in notices" :key="item.id" class="notice-item">
            <h3>{{ item.title }}</h3>
            <p>{{ item.content }}</p>
          </article>
        </div>
        <el-empty v-else description="暂未发布动态" />
      </div>

      <div class="card spotlight-panel">
        <div class="section-title panel-title">平台特色</div>
        <ul class="spotlight-list">
          <li>面向普通用户提供宠物档案浏览、条件筛选、详情查看与公告查阅。</li>
          <li>首页重点突出狗狗、猫咪、小宠和爱心服务四类主题内容。</li>
          <li>后台统一维护宠物资料、分类标签、首页轮播和平台公告，保证信息发布清晰一致。</li>
        </ul>
      </div>
    </section>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getCategories, getRecommendProducts } from '../api/product'
import { getPublicBanners, getPublicNotices } from '../api/content'
import ProductCard from '../components/ProductCard.vue'

const router = useRouter()
const recommendList = ref([])
const categories = ref([])
const notices = ref([])
const slides = ref([])

const openBannerTarget = (item) => {
  const target = String(item?.target || '').trim()
  if (!target) return
  if (/^\/front\/product\/detail\?id=\d+$/i.test(target)) {
    const id = target.match(/id=(\d+)/i)?.[1]
    if (id) {
      router.push(`/info/${id}`)
      return
    }
  }
  if (target.startsWith('/products/')) {
    router.push(target.replace('/products/', '/info/'))
    return
  }
  if (target.startsWith('/info/') || target.startsWith('/announcements')) {
    router.push(target)
  }
}

const defaultSlides = [
  {
    title: '遇见有缘毛孩子，开启温暖陪伴',
    summary: '围绕宠物档案、领养信息、平台公告和后台维护，构建清晰完整的宠物信息平台首页。',
    imageUrl: '/images/agri-banner-1.png?v=pet-shell'
  },
  {
    title: '支持分类浏览与多维筛选',
    summary: '支持按分类查看宠物档案，并结合标签与说明快速了解不同宠物的习性特点。',
    imageUrl: '/images/agri-banner-2.png?v=pet-shell'
  },
  {
    title: '让宠物信息更清晰可查',
    summary: '覆盖宠物信息维护、平台公告发布、分类管理与用户中心等完整业务流程。',
    imageUrl: '/images/agri-banner-3.png?v=pet-shell'
  }
]

onMounted(async () => {
  const [recommend, categoryList, noticeList, bannerList] = await Promise.allSettled([
    getRecommendProducts(),
    getCategories(),
    getPublicNotices(),
    getPublicBanners()
  ])

  if (recommend.status === 'fulfilled') {
    recommendList.value = Array.isArray(recommend.value) ? recommend.value : []
  }
  if (categoryList.status === 'fulfilled') {
    categories.value = Array.isArray(categoryList.value) ? categoryList.value : []
  }
  if (noticeList.status === 'fulfilled') {
    notices.value = (Array.isArray(noticeList.value) ? noticeList.value : []).slice(0, 3)
  }
  if (bannerList.status === 'fulfilled') {
    const safeBanners = (Array.isArray(bannerList.value) ? bannerList.value : []).filter((item) => item?.imageUrl)
    slides.value = safeBanners.length
      ? safeBanners.map((item) => ({
          title: item.title || '宠物主题轮播',
          summary: item.summary || item.subtitle || item.description || '欢迎查看宠物档案、平台公告与温暖陪伴故事。',
          imageUrl: item.imageUrl,
          target: item.linkUrl
        }))
      : defaultSlides
  } else {
    slides.value = defaultSlides
  }

  if (recommend.status === 'rejected' && categoryList.status === 'rejected' && noticeList.status === 'rejected') {
    ElMessage.warning('首页部分数据加载失败，已展示默认内容')
  }
})
</script>

<style scoped>
.hero {
  display: grid;
  grid-template-columns: minmax(0, 1.8fr) minmax(280px, 0.9fr);
  gap: 18px;
}

.hero-main,
.hero-side {
  padding: 16px;
}

.slide {
  height: 340px;
  border-radius: 12px;
  background-size: cover;
  background-position: center;
  overflow: hidden;
}

.overlay {
  height: 100%;
  padding: 38px;
  background: linear-gradient(100deg, rgba(45, 91, 102, 0.82), rgba(45, 91, 102, 0.16));
}

.eyebrow {
  display: inline-block;
  margin-bottom: 14px;
  padding: 6px 10px;
  border-radius: 999px;
  color: #fdf8f5;
  background: rgba(255, 255, 255, 0.16);
  font-size: 12px;
  letter-spacing: 0.12em;
}

h1 {
  margin: 0;
  max-width: 520px;
  font-size: 38px;
  color: #fff;
}

p {
  margin: 12px 0 18px;
  max-width: 520px;
  color: rgba(255, 255, 255, 0.92);
  line-height: 1.8;
}

.hero-actions {
  display: flex;
  gap: 12px;
}

.hero-side {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.side-title {
  margin: 4px 0 18px;
  font-size: 22px;
  font-weight: 700;
  color: var(--brand-deep);
}

.category-link {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 0;
  border-bottom: 1px solid var(--line-color);
  color: var(--text-secondary);
  transition: color .2s ease, transform .2s ease;
}

.category-link:hover {
  color: var(--brand-deep);
  transform: translateX(4px);
}

.section-block {
  margin-top: 30px;
}

.section-desc {
  color: var(--text-secondary);
}

.content-grid {
  display: grid;
  grid-template-columns: 1.3fr 0.9fr;
  gap: 18px;
}

.notice-panel,
.spotlight-panel {
  padding: 22px;
}

.panel-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.panel-title {
  margin-bottom: 0;
  font-size: 24px;
}

.more-link {
  color: var(--brand-main);
}

.notice-list {
  display: grid;
  gap: 16px;
  margin-top: 18px;
}

.notice-item {
  padding-bottom: 16px;
  border-bottom: 1px solid var(--line-color);
}

.notice-item:last-child {
  padding-bottom: 0;
  border-bottom: 0;
}

.notice-item h3 {
  margin: 0 0 8px;
  color: var(--brand-deep);
}

.notice-item p {
  margin: 0;
  color: var(--text-secondary);
}

.spotlight-list {
  margin: 18px 0 0;
  padding-left: 18px;
  color: var(--text-secondary);
  line-height: 1.9;
}

@media (max-width: 960px) {
  .hero,
  .content-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .hero-actions {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
