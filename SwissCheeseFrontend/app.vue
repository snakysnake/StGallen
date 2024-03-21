<template>
  <div>
    <Stats />
    <section class="flex w-full">
      <div class="w-full max-w-xl m-4">
        <SimpleList />
      </div>
      <div>
        <Menu as="div" class="relative inline-block text-left ms-4">
          <div>
            <MenuButton
              class="inline-flex w-full justify-center gap-x-1.5 rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">
              {{ rooms[currentRoomIndex].name }}
              <ChevronDownIcon class="-mr-1 h-5 w-5 text-gray-400" aria-hidden="true" />
            </MenuButton>
          </div>
          <transition enter-active-class="transition ease-out duration-100"
            enter-from-class="transform opacity-0 scale-95" enter-to-class="transform opacity-100 scale-100"
            leave-active-class="transition ease-in duration-75" leave-from-class="transform opacity-100 scale-100"
            leave-to-class="transform opacity-0 scale-95">
            <MenuItems
              class="absolute -right-15 z-10 mt-2 w-56 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
              <div class="py-1">
                <MenuItem v-for="(room, index) in rooms.length" @click="currentRoomIndex = index">
                <a class="cursor-pointer"
                  :class="[rooms[index].id === room.id ? 'bg-gray-100 text-gray-900' : 'text-gray-700', 'block px-4 py-2 text-sm']">{{
                rooms[index].name }}</a>
                </MenuItem>
              </div>
            </MenuItems>
          </transition>
        </Menu>
        <TwoDimensionalMap :people="rooms[currentRoomIndex].people" :height="rooms[currentRoomIndex].height"
          :width="rooms[currentRoomIndex].width" :name="rooms[currentRoomIndex].name">
          <img :src="rooms[currentRoomIndex].image" :alt="rooms[currentRoomIndex].name">
        </TwoDimensionalMap>
      </div>
    </section>
    <UserTable />
    <BetterModal :active="modalOpen" @close="modalOpen = false">
      <DangerModalContent h2="Evacuate Room" h3="Do you want to evacuate this room? This can not be undone."
        @confirm="sendIt" @abort="modalOpen = false" />
    </BetterModal>
  </div>
</template>

<script setup>
import { Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/vue'
import { ChevronDownIcon } from '@heroicons/vue/20/solid'
</script>


<script>
export default {
  data() {
    return {
      modalOpen: false,
      currentRoomIndex: 0,
      rooms: [
        {
          id: 1,
          people: 44,
          height: 800,
          width: 1000,
          image: "/sketch.jpg",
          name: "Room 1",
        },
        {
          id: 2,
          people: 73,
          height: 800,
          width: 1000,
          image: "/floorplan2.png",
          name: "Room 2",
        },
        {
          id: 3,
          people: 21,
          height: 800,
          width: 1000,
          image: "/floorplan3.jpg",
          name: "Room 3",
        }
      ]
    }
  },
}
</script>