<template>
    <div class="p-2 rounded-full cursor-pointer" :style="`left: ${xPos}px; top: ${yPos}px;`" :class="parentClasses"
        @click="$emit('selected', person)">
        <div class="relative">
            <div class="p-2 absolute transition-opacity rounded-full"
                :style="`left: -${movementAmount}px; top: -${movementAmount}px; padding: ${movementAmount}px;`"
                :class="childClasses">
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: {
        initXPos: {
            type: Number,
            default: 10,
        },
        initYPos: {
            type: Number,
            default: 10
        },
        height: {
            type: Number,
            default: 50
        },
        width: {
            type: Number,
            default: 100
        },
        person: {
            type: Object,
            default: () => { }
        }
    },
    computed: {
        parentClasses() {
            if (!this.person.evacuate) {
                return "bg-green-400";
            }
            return "bg-red-400"
        },
        childClasses() {
            if (!this.person.evacuate) {
                if (this.movedRecently) {
                    return "opacity-50 bg-green-200";
                }
                return "opacity-0 bg-green-200"
            }
            else {
                if (this.movedRecently) {
                    return "opacity-50 bg-red-200";
                }
                return "opacity-0 bg-red-200"
            }
        }
    },
    data() {
        return {
            wait: false,
            yPos: 0,
            xPos: 0,
            movedRecently: false,
            movementAmount: 0,
        }
    },
    watch: {
        async yPos(nPos, oldPos) {
            this.movementAmount = Math.ceil(Math.random() * 25);
            if (!this.wait) {
                if (this.yPos > this.height - 10 || this.yPos < 2) {
                    this.yPos = this.initYPos;
                }
                this.wait = true;
                await this.sleep(Math.ceil(Math.random() * 500) * this.movementAmount);
                this.move();
            }
            this.wait = false;
        },
        async xPos(nPos, oldPos) {
            this.movementAmount = Math.ceil(Math.random() * 25);
            if (!this.wait) {
                if (this.xPos > this.width - 10 || this.xPos < 2) {
                    this.xPos = this.initXPos;
                }
                this.wait = true;
                await this.sleep(Math.floor(Math.random() * 500) * this.movementAmount);
                this.move();
            }
            this.wait = false;
        },
        async movedRecently(newVal) {
            if (newVal === true) {
                await this.sleep(300);
                this.movedRecently = false;
            }
        }
    },
    mounted() {
        this.xPos = this.initXPos;
        this.yPos = this.initYPos;
    },
    methods: {
        move() {
            // Function to simulate movement
            const rand = Math.random();
            if (rand <= 0.25) {
                this.right();
            }
            else if (rand <= 0.5) {
                this.left();
            }
            else if (rand <= 0.75) {
                this.up();
            }
            else {
                this.down();
            }
        },
        up() {
            this.yPos = this.yPos + this.movementAmount;
            this.movedRecently = true;
        },
        down() {
            this.yPos = this.yPos - this.movementAmount;
            this.movedRecently = true;
        },
        left() {
            this.xPos = this.xPos - this.movementAmount;
            this.movedRecently = true;
        },
        right() {
            this.xPos = this.xPos + this.movementAmount;
            this.movedRecently = true;
        },
        sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }
}
</script>