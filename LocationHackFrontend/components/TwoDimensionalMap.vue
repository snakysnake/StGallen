<template>
    <div class="text-center m-3 overflow-hidden border-2"
        :style="`width: ${width}px; height: ${height}px; min-width: ${width}px; min-height: ${height}px;`">
        <div class="flex justify-between">
            <dd class="flex items-baseline">
                <UsersIcon class="w-7 h-7 m-2" />
                <p class="text-2xl font-semibold text-gray-900">{{ peeps.length }}</p>
            </dd>
            <h1 class="font-bold text-2xl p-2">{{ name }}</h1>
        </div>
        <div class="rounded-lg">
            <div class="relative border-t-2">
                <slot />
                <Minion class="absolute" v-for="person in peeps" :key="person" :person="person"
                    :init-x-pos="person.xPos" :init-y-pos="person.yPos" :height="height" :width="width"
                    @selected="selectPerson" @deleteme="deletePerson" @evacme="evacPerson" />
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
        },
        deletePerson(person) {
            this.$emit("deleteperson", person)
        },
        evacPerson(person) {
            this.$emit("evacperson", person);
        }
    }
}
</script>