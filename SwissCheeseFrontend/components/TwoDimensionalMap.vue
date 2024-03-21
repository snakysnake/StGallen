<template>
    <div class="text-center" :style="`max-width: ${width}px; max-height: ${height}px;min-width: ${width}px; min-height: ${height}px;`">
        <h1 class="font-bold text-xl">{{ name }}</h1>
        <div class="border-2 overflow-hidden">
            <div class="relative">
                <slot />
                <Person class="absolute" v-for="person in peeps" :key="person" :init-x-pos="person.xPos"
                    :init-y-pos="person.yPos" :height="height" :width="width" />

            </div>
        </div>
    </div>
</template>

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
        }
    },
    data() {
        return {
            peeps: [],
            modalOpen: false
        }
    },
    created() {
        console.log("created")
        const names = ["January", "February", "March", "April", "May", "June", "July"];

        for (let i = 0; i < this.people; i++) {
            const random = Math.floor(Math.random() * names.length);
            this.peeps.push({
                name: random,
                xPos: Math.floor(Math.random() * this.width),
                yPos: Math.floor(Math.random() * this.height)
            })
        }
    }
}
</script>