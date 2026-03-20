import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/user'

const routes = [
    { path: '/login', component: () => import('../views/LoginView.vue'), meta: { public: true } },
    {
        path: '/admin',
        component: () => import('../layouts/AdminLayout.vue'),
        meta: { auth: true, admin: true },
        children: [
            { path: '', redirect: '/admin/dashboard' },
            { path: 'dashboard', name: 'admin-dashboard', component: () => import('../views/admin/AdminDashboardView.vue') },
            { path: 'statistics', name: 'admin-statistics', component: () => import('../views/admin/AdminStatisticsView.vue') },
            { path: 'users', name: 'admin-users', component: () => import('../views/admin/AdminUserListView.vue') },
            { path: 'crops', name: 'admin-crops', component: () => import('../views/admin/AdminProductListView.vue'), meta: { moduleType: 'crop' } },
            { path: 'infos', name: 'admin-infos', component: () => import('../views/admin/AdminProductListView.vue'), meta: { moduleType: 'info' } },
            { path: 'categories', name: 'admin-categories', component: () => import('../views/admin/AdminCategoryManageView.vue') },
            { path: 'notices', name: 'admin-notices', component: () => import('../views/admin/AdminNoticeListView.vue') },
            { path: 'banners', name: 'admin-banners', component: () => import('../views/admin/AdminBannerListView.vue') },
            { path: 'password', name: 'admin-password', component: () => import('../views/admin/AdminPasswordView.vue') }
        ]
    },
    {
        path: '/',
        component: () => import('../layouts/UserLayout.vue'),
        children: [
            { path: '', name: 'home', component: () => import('../views/HomeView.vue') },
            { path: 'info', name: 'info-list', component: () => import('../views/ProductListView.vue') },
            { path: 'info/:id', name: 'info-detail', component: () => import('../views/ProductDetailView.vue') },
            { path: 'announcements', name: 'announcements', component: () => import('../views/AnnouncementListView.vue') },
            { path: 'announcements/:id', name: 'announcement-detail', component: () => import('../views/AnnouncementDetailView.vue') },
            { path: 'profile', name: 'profile', component: () => import('../views/ProfileView.vue'), meta: { auth: true } },
            { path: 'followed-items', alias: 'favorites', name: 'followed-items', component: () => import('../views/FavoritesView.vue'), meta: { auth: true } },
            { path: 'cart', redirect: '/info' },
            { path: 'checkout', redirect: '/info' },
            { path: 'orders', redirect: '/profile' },
            { path: 'address', redirect: '/profile' },
            { path: 'products', redirect: '/info' },
            { path: 'products/:id', redirect: (to) => `/info/${to.params.id}` }
        ]
    }
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

router.beforeEach(async (to) => {
    const userStore = useUserStore()
    if (userStore.isLogin && !userStore.user) {
        await userStore.fetchMe().catch(() => userStore.logout())
    }

    if (to.meta.auth && !userStore.isLogin) {
        return `/login?redirect=${encodeURIComponent(to.fullPath)}`
    }
    if (to.meta.admin && !userStore.isAdmin) {
        return '/'
    }
    if (to.path === '/login' && userStore.isLogin) {
        return userStore.isAdmin ? '/admin' : '/'
    }
})

export default router
