<template>
  <div>
    <NavBar />
    <ThreeDimensionLayers />
    <button type="button" @click="modalOpen = true"
      class="inline-flex items-center gap-x-2 rounded-md bg-red-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-red-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">
      Emergency
    </button>
    <BetterModal :active="modalOpen" @close="modalOpen = false">
      <DangerModalContent h2="Evacuate Room" @confirm="sendIt" />
    </BetterModal>
  </div>
</template>

<script>
export default {
  data() {
    return {
      modalOpen: false
    }
  },
}
</script>