<template>
    <div class="rounded-full cursor-pointer" :style="`left: ${xPos}px; top: ${yPos}px;`" :class="parentClasses"
        @click="$emit('selected', person)">
        <div class="relative">
            <img src="/minidance.gif" class="w-12 h-12" alt="">
            <div v-if="movedRecently" class="min-w-3 max-h-3 min-h-3 max-w-3 p-1 mb-1 -top-3 absolute text-xs -left-2">
                <div>
                    {{ lastMovement }}
                </div>
            </div>
        </div>
        <div class="p-2 absolute transition-opacity rounded-full"
            :style="`left: -${movementAmount}px; top: -${movementAmount}px; padding: ${movementAmount}px;`"
            :class="childClasses">
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
                return "";
            }
            return ""
        },
        childClasses() {
            if (!this.person.evacuate) {
                if (this.movedRecently) {
                    return "opacity-50 bg-green-200";
                }
                return "opacity-0"
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
            lastMovement: ""
        }
    },
    watch: {
        async yPos(nPos, oldPos) {
            if (!this.person.evacuate) {
                if (Math.random() > 0.999) {
                    this.$emit("evacme", this.person);
                }
            }
            if (this.person.evacuate) {
                this.emitDeletionIfNeeded()
            }
            this.movementAmount = Math.ceil(Math.random() * 25);

            if (this.person.evacuate) {
                this.movementAmount * 2;
            }
            if (!this.wait) {
                if (!this.person.evacuate) {
                    if (this.yPos > this.height - 10 || this.yPos < 2) {
                        this.yPos = this.initYPos;
                    }
                }
                this.wait = true;
                let sleepTime = Math.ceil(Math.random() * 200) * this.movementAmount;
                if (this.person.evacuate) {
                    sleepTime / 100
                }

                await this.sleep(sleepTime);

                this.move();
            }
            this.wait = false;
        },
        async xPos(nPos, oldPos) {
            if (this.person.evacuate) {
                this.emitDeletionIfNeeded()
            }
            this.movementAmount = Math.ceil(Math.random() * 25);

            if (this.person.evacuate) {
                this.movementAmount * 2;
            }
            if (!this.wait) {
                if (!this.person.evacuate) {
                    if (this.xPos > this.width - 10 || this.xPos < 2) {
                        this.xPos = this.initXPos;
                    }
                }
                this.wait = true;
                let sleepTime = Math.floor(Math.random() * 200) * this.movementAmount;
                if (this.person.evacuate) {
                    sleepTime / 100
                }

                await this.sleep(sleepTime);

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
        emitDeletionIfNeeded() {
            if (this.yPos < 0 || this.xPos < 0 || this.xPos > this.width || this.yPos > this.height) {
                this.$emit("deleteme", this.person);
            }
        },
        move() {
            // Function to simulate movement
            let rand = Math.random();

            if (this.person.evacuate) {
                // invite person to move to closest edge...
                const differences = {
                    left: this.xPos,
                    top: this.yPos,
                    right: this.width - this.xPos,
                    bottom: this.height - this.yPos
                };

                // Find the minimum difference
                let minDifference = Infinity;
                let minSides = [];

                for (const [side, difference] of Object.entries(differences)) {
                    if (difference < minDifference) {
                        minDifference = difference;
                        minSides = [side]; // Reset minSides if a new minimum is found
                    } else if (difference === minDifference) {
                        minSides.push(side); // Add side to minSides if it has the same minimum difference
                    }
                }


                // Randomly select one of the sides from minSides
                let randomMinSide = minSides[Math.floor(Math.random() * minSides.length)];
                if (differences.bottom < randomMinSide) {
                    randomMinSide = 'bottom';
                }

                if (Math.random() < 90) {
                    if (randomMinSide === 'left') {
                        this.left();
                    }

                    if (randomMinSide === 'right') {
                        this.right();
                    }

                    if (randomMinSide === 'top') {
                        this.up();
                    }

                    if (randomMinSide === 'bottom') {
                        this.down();
                    }
                }
            }
            else {
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
            }
        },
        up() {
            this.yPos = this.yPos - this.movementAmount;
            this.movedRecently = true;
            this.lastMovement = "up"
        },
        down() {
            this.yPos = this.yPos + this.movementAmount;
            this.movedRecently = true;
            this.lastMovement = "down"
        },
        left() {
            this.xPos = this.xPos - this.movementAmount;
            this.movedRecently = true;
            this.lastMovement = "left";
        },
        right() {
            this.xPos = this.xPos + this.movementAmount;
            this.movedRecently = true;
            this.lastMovement = "right";
        },
        sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    }
}
</script>