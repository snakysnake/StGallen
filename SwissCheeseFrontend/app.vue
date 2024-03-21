<template>
  <div>
    <NavBar />
    <button type="button" @click="modalOpen = true"
      class="inline-flex items-center gap-x-2 rounded-md bg-red-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-red-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">
      Emergency
    </button>
    <div class="flex align-middle">
      <InputWithLabel type="checkbox" v-for="room in rooms" v-model="room.show" :label="room.name" />
    </div>
    <div class="flex overflow-scroll flex-nowrap">
      <div v-for="room in rooms">
        <TwoDimensionalMap v-if="room.show" :people="room.people" :height="room.height" :width="room.width"
          :name="room.name">
          <img :src="room.image" :alt="room.name">
        </TwoDimensionalMap>
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
      modalOpen: false,
      rooms: [
        {
          people: 20,
          height: 800,
          width: 1000,
          image: "/sketch.jpg",
          name: "Room 1",
          show: true
        },
        {
          people: 20,
          height: 800,
          width: 1000,
          image: "/floorplan2.png",
          name: "Room 2",
          show: true
        },
        {
          people: 20,
          height: 800,
          width: 1000,
          image: "/floorplan3.jpg",
          name: "Room 3",
          show: true
        }
      ]
    }
  },
}
</script>