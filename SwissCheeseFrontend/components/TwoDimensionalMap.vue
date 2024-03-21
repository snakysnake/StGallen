<template>
    <div class="text-center m-3"
        :style="`max-width: ${width}px; max-height: ${height}px;min-width: ${width}px; min-height: ${height}px;`">
        <div class="flex justify-between">
            <dd class="flex items-baseline">
                <UsersIcon class="w-7 h-7 m-2" />
                <p class="text-2xl font-semibold text-gray-900">{{ peeps.length }}</p>
            </dd>
            <h1 class="font-bold text-2xl p-2">{{ name }}</h1>
        </div>
        <div class="border-2 rounded-lg overflow-hidden">
            <div class="relative">
                <slot />
                <Person class="absolute" v-for="person in peeps" :key="person" :person="person"
                    :init-x-pos="person.xPos" :init-y-pos="person.yPos" :height="height" :width="width"
                    @selected="selectPerson" />
            </div>
        </div>
    </div>
</template>

<script setup>
import { UsersIcon } from '@heroicons/vue/24/outline'
</script>

<script>
export default {
    props: {
        width: {
            type: Number,
            default: 100
        },
        height: {
            type: Number,
            default: 50
        },
        people: {
            type: Number,
            default: 1
        },
        name: {
            type: String,
            default: "Room N"
        },
        peeps: {
            type: Array,
            default: () => []
        }
    },
    data() {
        return {
            modalOpen: false,
            selectedPerson: undefined
        }
    },
    methods: {
        selectPerson(person) {
            this.selectedPerson = person;
            this.$emit("selected", person);
        }
    }
}
</script>