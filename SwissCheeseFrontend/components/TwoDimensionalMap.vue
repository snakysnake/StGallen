<template>
    <div class="border-2 overflow-hidden" :style="`max-width: ${width}px; max-height: ${height}px;`">
        <div class="relative">
            <img src="/sketch.jpg" alt="Floorplan">
            <Person class="absolute" v-for="person in peeps" :key="person" :init-x-pos="person.xPos"
                :init-y-pos="person.yPos" :height="height" :width="width" />

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
            console.log("OKKK")
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