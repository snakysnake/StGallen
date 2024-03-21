<template>
    <div class="text-center"
        :style="`max-width: ${width}px; max-height: ${height}px;min-width: ${width}px; min-height: ${height}px;`">
        <h1 class="font-bold text-2xl p-2">{{ name }}</h1>
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
            modalOpen: false,
            selectedPerson: undefined
        }
    },
    created() {
        console.log("created")
        const names = ["Jan", "Maria", "Mark", "Andreas", "Markovic", "Pankaj", "Juli", "Anton", "Steven"];
        const emails = ["justinbieber@gmail.com", "im@fify.cent", "dont@fwme.com", "supercoolhacker@gmail.com"];
        const phones = ["00491239132", "0123812389123", "0234812334", "004512381239", "0023932490"];

        for (let i = 0; i < this.people; i++) {
            const name = names[Math.floor(Math.random() * names.length)];
            const mail = emails[Math.floor(Math.random() * emails.length)];
            const phone = phones[Math.floor(Math.random() * phones.length)];

            this.peeps.push({
                name: name,
                email: mail,
                phone: phone,
                id: Math.ceil(Math.random() * 100000),
                xPos: Math.floor(Math.random() * this.width),
                yPos: Math.floor(Math.random() * this.height),
                evacuated: false
            })
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