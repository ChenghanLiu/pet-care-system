<template>
  <div class="page-wrap">
    <div class="section-title">我的资料</div>
    <div class="quick-links">
      <el-button plain @click="$router.push('/followed-items')">查看我的关注萌宠</el-button>
    </div>
    <el-alert v-if="loadError" :title="loadError" type="warning" :closable="false" style="margin-bottom: 16px; max-width: 720px;" />
    <div class="card" style="padding:20px;max-width:720px;">
      <el-form :model="form" label-width="90px">
        <el-form-item label="用户ID"><span>{{ form.id }}</span></el-form-item>
        <el-form-item label="用户名"><span>{{ form.username }}</span></el-form-item>
        <el-form-item label="角色"><span>{{ form.role === 'USER' ? '爱心用户' : form.role }}</span></el-form-item>
        <el-form-item label="昵称"><el-input v-model="form.nickname" placeholder="请输入展示昵称" /></el-form-item>
        <el-form-item label="手机号"><el-input v-model="form.phone" placeholder="用于接收平台联系信息" /></el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="saving" @click="save">保存资料</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { me, updateMe } from '../api/auth'

const saving = ref(false)
const loadError = ref('')
const form = ref({ id: '-', username: '-', role: '-', nickname: '', phone: '' })

const load = async () => {
  loadError.value = ''
  try {
    const data = await me()
    form.value = {
      id: data?.id ?? '-',
      username: data?.username ?? '-',
      role: data?.role ?? '-',
      nickname: data?.nickname || '',
      phone: data?.phone || ''
    }
  } catch {
    loadError.value = '个人资料加载失败，请重新登录后再试。'
  }
}

const save = async () => {
  saving.value = true
  try {
    await updateMe({ nickname: form.value.nickname, phone: form.value.phone })
    ElMessage.success('资料已保存')
    await load()
  } finally {
    saving.value = false
  }
}

onMounted(load)
</script>

<style scoped>
.quick-links {
  margin: 16px 0;
}
</style>
