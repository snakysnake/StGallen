<template>
  <div>
    <NavBar />
    <button type="button" @click="modalOpen = true"
      class="inline-flex items-center gap-x-2 rounded-md bg-red-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-red-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">
      Emergency
    </button>
    <div class="justify-center">
      <TwoDimensionalMap :people="20" :height="800" :width="1000">
        <img src="/sketch.jpg" alt="Floorplan">
      </TwoDimensionalMap>
      <TwoDimensionalMap :people="100" :height="800" :width="1000">
        <img src="/sketch.jpg" alt="Floorplan">
      </TwoDimensionalMap>
      <TwoDimensionalMap :people="10" :height="800" :width="1000">
        <img src="/sketch.jpg" alt="Floorplan">
      </TwoDimensionalMap>
      <div class="border-2 w-[200px]">
        <h1>Act</h1>
      </div>
    </div>
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