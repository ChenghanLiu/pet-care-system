<template>
  <div class="page-wrap">
    <div class="section-title">首页农业专题图管理</div>
    <div class="card" style="padding:16px;">
      <div class="toolbar-copy">
        首页专题图用于丰富演示首页视觉，不属于核心业务流程，建议仅维护少量精选内容。
      </div>
      <div style="margin:12px 0;">
        <el-button type="primary" @click="openCreate">新增专题图</el-button>
      </div>
      <el-table :data="banners" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="专题标题" min-width="180" />
        <el-table-column label="专题配图" width="110">
          <template #default="{ row }">
            <el-image v-if="row.imageUrl" :src="row.imageUrl" fit="cover" style="width:60px;height:60px;border-radius:4px;" />
            <span v-else>--</span>
          </template>
        </el-table-column>
        <el-table-column prop="linkUrl" label="展示说明 / 跳转链接" min-width="220" show-overflow-tooltip />
        <el-table-column prop="sort" label="排序" width="90" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">{{ Number(row.status) === 1 ? '启用' : '禁用' }}</template>
        </el-table-column>
        <el-table-column label="操作" width="160">
          <template #default="{ row }">
            <el-button link type="primary" @click="openEdit(row)">编辑</el-button>
            <el-button link type="danger" @click="remove(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog v-model="visible" :title="form.id ? '编辑专题图' : '新增专题图'" width="520px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="专题标题"><el-input v-model="form.title" placeholder="请输入首页农业专题标题" /></el-form-item>
        <el-form-item label="专题图片">
          <div class="image-upload-field">
            <el-upload
              :show-file-list="false"
              accept="image/jpeg,image/png,image/gif,image/webp"
              :http-request="uploadBannerImage"
            >
              <el-button :loading="uploading">上传专题图</el-button>
            </el-upload>
            <el-input v-model="form.imageUrl" placeholder="上传后自动填写，也可手动输入图片 URL" />
          </div>
        </el-form-item>
        <el-form-item label="图片预览">
          <el-image
            v-if="form.imageUrl"
            :src="form.imageUrl"
            fit="cover"
            style="width:120px;height:80px;border-radius:6px;"
          />
          <div v-else class="image-fallback">请先上传图片</div>
        </el-form-item>
        <el-form-item label="展示说明"><el-input v-model="form.linkUrl" placeholder="可填写跳转链接或专题摘要说明" /></el-form-item>
        <el-form-item label="排序"><el-input-number v-model="form.sort" :min="0" /></el-form-item>
        <el-form-item label="状态">
          <el-select v-model="form.status" style="width:100%">
            <el-option :value="1" label="启用" />
            <el-option :value="0" label="禁用" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="visible = false">取消</el-button>
        <el-button type="primary" @click="submit">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { createAdminBanner, deleteAdminBanner, getAdminBanners, updateAdminBanner, uploadAdminImage } from '../../api/admin'

const loading = ref(false)
const banners = ref([])
const visible = ref(false)
const uploading = ref(false)
const form = ref({ id: null, title: '', imageUrl: '', linkUrl: '', sort: 0, status: 1 })

const load = async () => {
  loading.value = true
  try {
    banners.value = await getAdminBanners()
  } finally {
    loading.value = false
  }
}

const openCreate = () => {
  form.value = { id: null, title: '', imageUrl: '', linkUrl: '', sort: 0, status: 1 }
  visible.value = true
}

const openEdit = (row) => {
  form.value = {
    id: row.id,
    title: row.title || '',
    imageUrl: row.imageUrl || '',
    linkUrl: row.linkUrl || '',
    sort: Number(row.sort || 0),
    status: Number(row.status || 0)
  }
  visible.value = true
}

const uploadBannerImage = async ({ file }) => {
  uploading.value = true
  try {
    const result = await uploadAdminImage(file)
    form.value.imageUrl = result.url
    ElMessage.success('专题图上传成功')
  } finally {
    uploading.value = false
  }
}

const submit = async () => {
  const payload = {
    title: form.value.title,
    imageUrl: form.value.imageUrl,
    linkUrl: form.value.linkUrl,
    sort: form.value.sort,
    status: form.value.status
  }
  if (form.value.id) {
    await updateAdminBanner(form.value.id, payload)
  } else {
    await createAdminBanner(payload)
  }
  ElMessage.success('保存成功')
  visible.value = false
  await load()
}

const remove = async (id) => {
  await ElMessageBox.confirm('确认删除该专题图吗？', '提示', { type: 'warning' })
  await deleteAdminBanner(id)
  ElMessage.success('删除成功')
  await load()
}

onMounted(load)
</script>

<style scoped>
.toolbar-copy {
  color: var(--text-secondary);
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

.image-fallback {
  width: 120px;
  height: 80px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-secondary);
  background: #f5f7fa;
}
</style>
