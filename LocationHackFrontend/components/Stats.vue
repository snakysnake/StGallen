<template>
    <div class="p-3">
        <h3 class="text-base font-semibold leading-6 text-gray-900">Today</h3>
        <dl class="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-3">
            <div v-for="item in stats" :key="item.name"
                class="overflow-hidden rounded-lg bg-white px-4 py-5 shadow sm:p-6">
                <dt class="truncate text-sm font-medium text-gray-500">{{ item.name }}</dt>
                <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">{{ item.stat }}</dd>
            </div>
        </dl>
    </div>
</template>

<script>
export default {
    props: {
        stats: {
            type: Array,
            default: []
        }
    }
}
</script>