<template>
  <div class="page-wrap">
    <div class="section-title">宠物分类管理</div>

    <div class="grid-wrap">
      <div class="card panel">
        <div class="panel-head">
          <div class="panel-title">一级宠物分类</div>
          <el-button type="primary" @click="openCategoryCreate">新增一级分类</el-button>
        </div>
        <el-table :data="categories" v-loading="loading">
          <el-table-column prop="name" label="分类名称" min-width="160" />
          <el-table-column prop="sort" label="排序" width="90" />
          <el-table-column label="状态" width="100">
            <template #default="{ row }">{{ Number(row.status) === 1 ? '启用' : '停用' }}</template>
          </el-table-column>
          <el-table-column label="操作" width="160">
            <template #default="{ row }">
              <el-button link type="primary" @click="openCategoryEdit(row)">编辑</el-button>
              <el-button link type="danger" @click="removeCategory(row.id)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <div class="card panel">
        <div class="panel-head">
          <div class="panel-title">二级宠物标签</div>
          <el-button type="primary" @click="openSubcategoryCreate">新增二级标签</el-button>
        </div>
        <el-table :data="subcategories" v-loading="loading">
          <el-table-column label="所属一级分类" min-width="160">
            <template #default="{ row }">{{ categoryName(row.categoryId) }}</template>
          </el-table-column>
          <el-table-column prop="name" label="名称" min-width="140" />
          <el-table-column prop="sort" label="排序" width="90" />
          <el-table-column label="状态" width="100">
            <template #default="{ row }">{{ Number(row.status) === 1 ? '启用' : '停用' }}</template>
          </el-table-column>
          <el-table-column label="操作" width="160">
            <template #default="{ row }">
              <el-button link type="primary" @click="openSubcategoryEdit(row)">编辑</el-button>
              <el-button link type="danger" @click="removeSubcategory(row.id)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>

    <el-dialog v-model="categoryVisible" :title="categoryForm.id ? '编辑一级分类' : '新增一级分类'" width="460px">
      <el-form :model="categoryForm" label-width="88px">
        <el-form-item label="分类名称"><el-input v-model="categoryForm.name" /></el-form-item>
        <el-form-item label="排序"><el-input-number v-model="categoryForm.sort" :min="0" /></el-form-item>
        <el-form-item label="状态">
          <el-select v-model="categoryForm.status" style="width:100%">
            <el-option :value="1" label="启用" />
            <el-option :value="0" label="停用" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="categoryVisible = false">取消</el-button>
        <el-button type="primary" @click="submitCategory">保存</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="subcategoryVisible" :title="subcategoryForm.id ? '编辑二级标签' : '新增二级标签'" width="480px">
      <el-form :model="subcategoryForm" label-width="88px">
        <el-form-item label="所属一级分类">
          <el-select v-model="subcategoryForm.categoryId" style="width:100%">
            <el-option v-for="item in categories" :key="item.id" :label="item.name" :value="Number(item.id)" />
          </el-select>
        </el-form-item>
        <el-form-item label="标签名称"><el-input v-model="subcategoryForm.name" placeholder="请输入二级宠物标签名称" /></el-form-item>
        <el-form-item label="排序"><el-input-number v-model="subcategoryForm.sort" :min="0" /></el-form-item>
        <el-form-item label="状态">
          <el-select v-model="subcategoryForm.status" style="width:100%">
            <el-option :value="1" label="启用" />
            <el-option :value="0" label="停用" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="subcategoryVisible = false">取消</el-button>
        <el-button type="primary" @click="submitSubcategory">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  createAdminCategory,
  createAdminSubcategory,
  deleteAdminCategory,
  deleteAdminSubcategory,
  getAdminCategories,
  getAdminSubcategories,
  updateAdminCategory,
  updateAdminSubcategory
} from '../../api/admin'

const loading = ref(false)
const categories = ref([])
const subcategories = ref([])
const categoryVisible = ref(false)
const subcategoryVisible = ref(false)
const categoryForm = ref({ id: null, name: '', sort: 0, status: 1 })
const subcategoryForm = ref({ id: null, categoryId: undefined, name: '', sort: 0, status: 1 })

const categoryName = (id) => categories.value.find((item) => Number(item.id) === Number(id))?.name || '-'

const load = async () => {
  loading.value = true
  try {
    const [categoryList, subcategoryList] = await Promise.all([getAdminCategories(), getAdminSubcategories()])
    categories.value = categoryList
    subcategories.value = subcategoryList
  } finally {
    loading.value = false
  }
}

const openCategoryCreate = () => {
  categoryForm.value = { id: null, name: '', sort: 0, status: 1 }
  categoryVisible.value = true
}

const openCategoryEdit = (row) => {
  categoryForm.value = { id: row.id, name: row.name || '', sort: Number(row.sort || 0), status: Number(row.status || 0) }
  categoryVisible.value = true
}

const submitCategory = async () => {
  if (categoryForm.value.id) {
    await updateAdminCategory(categoryForm.value.id, categoryForm.value)
  } else {
    await createAdminCategory(categoryForm.value)
  }
  ElMessage.success('一级分类已保存')
  categoryVisible.value = false
  await load()
}

const removeCategory = async (id) => {
  await ElMessageBox.confirm('确认删除该一级分类吗？', '提示', { type: 'warning' })
  await deleteAdminCategory(id)
  ElMessage.success('删除成功')
  await load()
}

const openSubcategoryCreate = () => {
  subcategoryForm.value = { id: null, categoryId: categories.value[0] ? Number(categories.value[0].id) : undefined, name: '', sort: 0, status: 1 }
  subcategoryVisible.value = true
}

const openSubcategoryEdit = (row) => {
  subcategoryForm.value = {
    id: row.id,
    categoryId: Number(row.categoryId),
    name: row.name || '',
    sort: Number(row.sort || 0),
    status: Number(row.status || 0)
  }
  subcategoryVisible.value = true
}

const submitSubcategory = async () => {
  if (subcategoryForm.value.id) {
    await updateAdminSubcategory(subcategoryForm.value.id, subcategoryForm.value)
  } else {
    await createAdminSubcategory(subcategoryForm.value)
  }
  ElMessage.success('二级标签已保存')
  subcategoryVisible.value = false
  await load()
}

const removeSubcategory = async (id) => {
  await ElMessageBox.confirm('确认删除该二级标签吗？', '提示', { type: 'warning' })
  await deleteAdminSubcategory(id)
  ElMessage.success('删除成功')
  await load()
}

onMounted(load)
</script>

<style scoped>
.grid-wrap {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

.panel {
  padding: 16px;
}

.panel-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.panel-title {
  font-size: 18px;
  font-weight: 700;
  color: var(--brand-deep);
}

@media (max-width: 960px) {
  .grid-wrap {
    grid-template-columns: 1fr;
  }
}
</style>
