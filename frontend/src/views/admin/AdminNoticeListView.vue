<template>
  <div class="page-wrap">
    <div class="section-title">农业公告与通知管理</div>
    <div class="card" style="padding:16px;">
      <div style="margin-bottom:12px;">
        <el-button type="primary" @click="openCreate">新增公告通知</el-button>
      </div>
      <el-table :data="notices" v-loading="loading">
        <el-table-column prop="title" label="标题" min-width="220" />
        <el-table-column label="类型" width="120">
          <template #default="{ row }">{{ Number(row.type) === 2 ? '资讯解读' : '系统公告' }}</template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">{{ Number(row.status) === 1 ? '发布中' : '已下线' }}</template>
        </el-table-column>
        <el-table-column prop="publishTime" label="发布时间" min-width="180" />
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button link type="primary" @click="openEdit(row)">编辑公告</el-button>
            <el-button link type="danger" @click="remove(row)">删除公告</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog v-model="visible" :title="form.id ? '编辑公告通知' : '新增公告通知'" width="640px">
      <el-form :model="form" label-width="88px">
        <el-form-item label="标题"><el-input v-model="form.title" placeholder="请输入农业公告或通知标题" /></el-form-item>
        <el-form-item label="类型">
          <el-select v-model="form.type" style="width:100%">
            <el-option :value="1" label="系统公告" />
            <el-option :value="2" label="资讯解读" />
          </el-select>
        </el-form-item>
        <el-form-item label="内容"><el-input v-model="form.content" type="textarea" :rows="6" placeholder="用于填写农业公告、通知说明或资讯解读内容" /></el-form-item>
        <el-form-item label="发布时间"><el-date-picker v-model="form.publishTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" style="width:100%" /></el-form-item>
        <el-form-item label="状态">
          <el-select v-model="form.status" style="width:100%">
            <el-option :value="1" label="发布中" />
            <el-option :value="0" label="已下线" />
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
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { createAdminNotice, deleteAdminNotice, getAdminNotices, updateAdminNotice } from '../../api/admin'

const loading = ref(false)
const notices = ref([])
const visible = ref(false)
const submitting = ref(false)
const form = ref({ id: null, title: '', content: '', type: 1, status: 1, publishTime: '' })

const formatPublishTime = (value) => {
  const source = String(value ?? '').trim()
  if (!source) {
    return ''
  }
  return source.includes('T') ? source.replace('T', ' ').slice(0, 19) : source.slice(0, 19)
}

const load = async () => {
  loading.value = true
  try {
    notices.value = await getAdminNotices()
  } finally {
    loading.value = false
  }
}

const openCreate = () => {
  form.value = { id: null, title: '', content: '', type: 1, status: 1, publishTime: '' }
  visible.value = true
}

const openEdit = (row) => {
  form.value = {
    id: row.id,
    title: row.title || '',
    content: row.content || '',
    type: Number(row.type || 1),
    status: Number(row.status || 1),
    publishTime: formatPublishTime(row.publishTime)
  }
  visible.value = true
}

const submit = async () => {
  if (!form.value.title.trim()) {
    ElMessage.warning('请输入公告标题')
    return
  }
  if (!form.value.content.trim()) {
    ElMessage.warning('请输入公告内容')
    return
  }

  const payload = {
    ...form.value,
    title: form.value.title.trim(),
    content: form.value.content.trim(),
    publishTime: formatPublishTime(form.value.publishTime) || null
  }

  submitting.value = true
  try {
    if (form.value.id) {
      await updateAdminNotice(form.value.id, payload)
      ElMessage.success('公告通知已更新')
    } else {
      await createAdminNotice(payload)
      ElMessage.success('公告通知已新增')
    }
    visible.value = false
    await load()
  } finally {
    submitting.value = false
  }
}

const remove = async (row) => {
  await ElMessageBox.confirm(`确认删除公告《${row.title || '未命名公告'}》吗？`, '提示', { type: 'warning' })
  await deleteAdminNotice(row.id)
  ElMessage.success('公告通知已删除')
  await load()
}

onMounted(load)
</script>
