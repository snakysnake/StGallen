BetterModal.vue<template>
    <div class="w-screen z-50 fixed max-h-full flex backdrop-blur-md min-h-screen overflow-y-scroll top-0 right-0 left-0 justify-center p-1 sm:py-0 sm:px-10 pt-10 sm:pt-0 transition-all min-w-full"
        style="background-color: rgba(0, 0, 0, 0.2)" :class="hiddenClass">
        <Transition>
            <div v-if="active" tabindex="-1"
                class="top-0 right-0 left-0 mb-12 sm:mb-2 min-w-full md:min-w-[700px] lg:min-w-[700px] md:max-w-[1500px]">
                <div class="relative p-2 sm:p-4 w-full min-h-full md:h-auto">
                    <div
                        class="relative rounded-lg shadow sm:p-2 bg-white dark:bg-gray-900 dark:ring-1 dark:ring-indigo-600 lg:my-20 lg:mt-10">
                        <button type="button"
                            class="absolute top-2 right-2.5 text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center"
                            data-modal-toggle="popup-modal" @click="$emit('close')">
                            <svg aria-hidden="true" class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"
                                xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd"
                                    d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                                    clip-rule="evenodd" />
                            </svg>
                            <span class="sr-only">Close modal</span>
                        </button>
                        <div class="sm:min-h-[300px] lg:min-h-[330px] min-w-full">
                            <slot />
                        </div>
                    </div>
                </div>
            </div>
        </Transition>
    </div>
</template>

<script>
export default {
    props: {
        active: {
            type: Boolean,
            default: false,
        },
    },
    emits: ["close"],
    data() {
        return {
            hiddenClass: "hidden",
        };
    },
    watch: {
        async active() {
            if (!this.active) {
                this.hiddenClass = "opacity-0 backdrop-blur-sm";
                await this.sleep(300);
                this.hiddenClass = "hidden";
            } else {
                this.hiddenClass = "";
            }
        },
    },
    methods: {
        sleep(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        },
        toggleActive() {
            // eslint-disable-next-line vue/no-mutating-props
            this.active = !this.active;
            if (!this.active) {
                this.$emit("close");
            }
        },
    },
};
</script>

<style>
.v-enter-active,
.v-leave-active {
    transition: opacity 0.1s ease;
    transition: transform 0.2s ease;
}

.v-enter-from,
.v-leave-to {
    opacity: 0;
    transform: scale(0.5);
}
</style>