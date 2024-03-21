<template>
    <div class="bg-red-500 p-1 rounded-full" :style="`left: ${xPos}px; top: ${yPos}px;`">
        <div class="relative">
            <div class="p-2 bg-red-400 absolute transition-opacity rounded-full"
                :style="`left: -${movementAmount}px; top: -${movementAmount}px; padding: ${movementAmount}px;`"
                :class="movedRecently ? 'opacity-50' : 'opacity-0'">
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
        }
    },
    data() {
        return {
            stop: false,
            yPos: 0,
            xPos: 0,
            movedRecently: false,
            movementAmount: 0,
        }
    },
    watch: {
        async yPos() {
            if (!this.stop) {
                await this.sleep(Math.floor(Math.random() * 5000));
                if (!this.movedRecently) {
                    this.move();
                }

                if (this.yPos > this.height - 10 || this.yPos < 2) {
                    this.yPos = this.initYPos;
                }
            }
        },
        async xPos() {
            if (!this.stop) {
                await this.sleep(Math.floor(Math.random() * 5000));
                if (!this.movedRecently) {
                    this.move();
                }

                if (this.xPos > this.width - 10 || this.xPos < 2) {
                    this.xPos = this.initXPos;
                }
            }
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
            this.movementAmount = Math.floor(Math.random() * 50);

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
            if (this.yPos < this.movementAmount) {
                // correctional movement, down
                this.down();
            }
            else {
                // up
                this.yPos = this.yPos + this.movementAmount;
                this.movedRecently = true;
            }
        },
        down() {
            if (this.yPos > this.height - this.movementAmount) {
                // correctional movement, up
                this.up();
            }
            else {
                // down
                this.yPos = this.yPos - this.movementAmount;
                this.movedRecently = true;
            }
        },
        left() {
            if (this.xPos <= this.movementAmount) {
                // correctional movement, right
                this.right();
            }
            else {
                // left
                this.xPos = this.xPos - this.movementAmount;
                this.movedRecently = true;
            }
        },
        right() {
            if (this.xPos >= this.width + this.movementAmount) {
                // correctional movement, left
                this.left();
            }
            else {
                // right
                this.xPos = this.xPos + this.movementAmount;
                this.movedRecently = true;
            }
        },
        sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }
}
</script>