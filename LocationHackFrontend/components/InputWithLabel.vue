<!-- eslint-disable vue/no-mutating-props -->
<template>
    <div class="group" :class="orient === 'vertical' ? '' : 'mt-2'">
        <label v-if="label && type != 'checkbox' && type != 'color'" :for="realId"
            class="block mb-2 text-sm font-medium dark:text-white">{{ label }}
            <slot />
        </label>
        <input v-if="type == 'text'" :id="realId" type="text" :placeholder="placeholder" :value="modelValue"
            :disabled="disabled" :class="classList" :model="modelValue" :required="required" :maxlength="maxLength"
            :aria-describedby="describedById" @blur="$emit('input-blur')"
            @input="$emit('update:modelValue', $event.target.value)"
            @keyup.enter="$emit('inputEnter', $event.target.value)">
        <select v-else-if="type == 'select'" :id="realId" :class="classList" :disabled="disabled" :model="modelValue"
            @change="$emit('update:modelValue', $event.target.value)">
            <option v-if="!options">
                Missing options! Please provide this component with options.
            </option>
            <option v-for="option in options" :key="option" :value="option.value" :selected="selected == option.value">
                {{ option.text }}
            </option>
        </select>
        <input v-else-if="type == 'date'" :id="realId" type="date" :placeholder="placeholder" :value="modelValue"
            :disabled="disabled" :class="classList" :model="modelValue" :required="required"
            :aria-describedby="describedById" @blur="$emit('input-blur')"
            @input="$emit('update:modelValue', $event.target.value)"
            @keyup.enter="$emit('inputEnter', $event.target.value)">
        <textarea v-else-if="type == 'textarea'" :id="realId" rows="4" :model="modelValue" :class="classList"
            :value="modelValue" autocorrect="off" spellcheck="false" :placeholder="placeholder" :required="required"
            @input="$emit('update:modelValue', $event.target.value)"
            @keyup.enter="$emit('inputEnter', $event.target.value)" />
        <input v-else-if="type == 'time'" :id="realId" type="time" :value="modelValue" :required="required"
            :placeholder="placeholder" :class="classList" :model="modelValue" :aria-describedby="describedById"
            @input="$emit('update:modelValue', $event.target.value)">
        <div v-else-if="['range', 'timeline'].includes(type)">
            <input :id="realId" type="range" :required="required" :min="min" :max="max" :value="modelValue"
                :orient="orient" :disabled="disabled" :class="orient === 'vertical' ? 'rotate-180' : 'range'"
                :step="step" :style="style" :aria-describedby="describedById"
                @input="$emit('update:modelValue', $event.target.value)">
            <div v-if="step !== 0" class="w-full flex justify-between text-xs px-2" aria-hidden="true">
                <span v-for="index in amountOfDivisionSteps" :key="index" class="overflow-hidden cursor-pointer"
                    :class="divisionStepClass(index)" @click="modelValue = index - 1">|</span>
            </div>
        </div>
        <div v-else-if="type == 'checkbox' || type == 'color'" class="flex align-middle">
            <input v-if="modelValue && type == 'checkbox'" :id="realId" type="checkbox" :required="required" checked
                class="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-600" :value="modelValue" @input="$emit('update:modelValue', $event.target.checked)">
            <input v-else-if="!modelValue && type == 'checkbox'" :id="realId" type="checkbox" :required="required"
                class="h-4 w-4 rounded border-gray-300 text-indigo-600 focus:ring-indigo-600" :value="modelValue" @input="$emit('update:modelValue', $event.target.checked)">
            <input v-else-if="type == 'color'" :id="realId" type="color" :value="modelValue" :required="required"
                class="w-10 overflow-hidden h-8" :placeholder="placeholder" :model="modelValue"
                :aria-describedby="describedById" @input="$emit('update:modelValue', $event.target.value)">
            <label :for="realId" class="block pb-1 px-2 text-md font-medium dark:text-white h-full items-center">{{
        label }}
                <slot />
            </label>
        </div>
        <div v-else-if="type == 'toggle'">
            <Switch :id="realId" v-model="toggleState" :required="required" :disabled="disabled"
                :aria-describedby="describedById" :class="[
        toggleState ? 'bg-indigo-600' : 'bg-gray-200',
        'relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-indigo-600 focus:ring-offset-2',
    ]">
                <span class="sr-only">{{ description }}</span>
                <span aria-hidden="true" :class="[
        toggleState ? 'translate-x-5' : 'translate-x-0',
        'pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out',
    ]" />
            </Switch>
        </div>
        <input v-else-if="type == 'tel'" :id="realId" type="tel" :required="required" :value="modelValue"
            :placeholder="placeholder" :class="classList" :model="modelValue" :aria-describedby="describedById"
            @input="$emit('update:modelValue', $event.target.value)"
            @keyup.enter="$emit('inputEnter', $event.target.value)">
        <input v-else-if="type == 'password'" type="password" :required="required" :class="classList"
            :autocomplete="autocomplete" :minlength="minlength" :model="modelValue" :aria-describedby="describedById"
            @input="$emit('update:modelValue', $event.target.value)"
            @keyup.enter="$emit('inputEnter', $event.target.value)">
        <input v-else-if="type == 'email'" type="email" :class="classList" :model="modelValue" :value="modelValue"
            :required="required" :placeholder="placeholder" :aria-describedby="describedById"
            @input="$emit('update:modelValue', $event.target.value)"
            @keyup.enter="$emit('inputEnter', $event.target.value)">
        <div v-else-if="type == 'number'" class="relative">
            <div v-if="allowCurrency == 'true'">
                <span class="absolute left-1 pl-2 h-full flex items-center text-lg text-gray-200 z-10">
                    {{ chooseCurrency }}
                </span>

                <input :id="realId" type="number" inputmode="numeric" :disabled="disabled" :value="modelValue"
                    :placeholder="placeholder" :step="step" :min="min" :required="required" :class="classList"
                    class="pl-6 text-lg" :model="modelValue" :aria-describedby="describedById"
                    @input="$emit('update:modelValue', $event.target.value)"
                    @keyup.enter="$emit('inputEnter', $event.target.value)">
            </div>
            <input v-else :id="realId" type="number" inputmode="numeric" :disabled="disabled" :value="modelValue"
                :placeholder="placeholder" :step="step" :min="min" :required="required" :class="classList"
                :model="modelValue" :aria-describedby="describedById"
                @input="$emit('update:modelValue', $event.target.value)"
                @keyup.enter="$emit('inputEnter', $event.target.value)">
        </div>
        <p v-if="description.length > 0" :id="describedById" class="text-gray-700 dark:text-gray-200 text-xs p-1">
            {{ description }}
        </p>
    </div>
</template>

<script setup>
import { Switch } from "@headlessui/vue";
</script>

<script>
import md5 from "md5"; // we use md5 for id creation.. makes it kind of predictable for search engines, so random shit doesnt just change

// heavily inspired from:
// https://www.youtube.com/watch?v=CALrQCw41dI
// (...watch to understand v-model with custom components)

export default {
    props: {
        allowCurrency: {
            type: Boolean,
            default: false,
        },
        selected: {
            type: String,
            default: "",
        },
        modelValue: {},
        minlength: {
            type: Number,
            default: 0,
        },
        maxLength: {
            type: Number,
            default: undefined,
        },
        type: {
            type: String,
            default: "text",
        },
        id: {
            type: String,
            default: "",
        },
        orient: {
            type: String,
            default: "horizontal",
        },
        label: {
            type: String,
            default: "",
        },
        placeholder: {
            type: String,
            default: "",
        },
        description: {
            type: String,
            default: "",
        },
        min: {
            type: Number,
            default: 0,
        },
        max: {
            type: Number,
            default: 1,
        },
        autocomplete: {
            type: String,
            default: "",
        },
        disabled: {
            type: Boolean,
            default: false,
        },
        height: {
            type: Number,
            default: undefined,
        },
        width: {
            type: Number,
            default: undefined,
        },
        step: {
            type: Number,
            default: 0,
        },
        required: {
            type: Boolean,
            default: false,
        },
        options: {
            type: Array,
            default: () => [],
        },
    },
    emits: ["update:modelValue", "inputEnter"],
    data() {
        return {
            realId: "",
            toggleState: false,
            classList:
                "transition-all outline-none bg-gray-50 dark:bg-gray-600 dark:border-gray-800 dark:text-white dark:focus-within:border-dashed focus-within:border-indigo-600 border-2 border-gray-300 text-gray-900 text-sm rounded-lg focus-within:border-solid focus:outline-none block w-full p-2.5 group-active:-translate-y-1 group-active:transform",
        };
    },
    computed: {
        style() {
            return `height: ${this.height}px; width: ${this.width}px;`;
        },
        describedById() {
            return this.realId + "-help";
        },
        amountOfDivisionSteps() {
            const length = Math.floor(this.max - this.min);
            return Number(Math.floor(length / this.step) + 1);
        },
        chooseCurrency() {
            if (this.$config.public.deploymentCountry == "UK") {
                return "£";
            } else {
                return "€";
            }
        },
    },
    watch: {
        toggleState() {
            this.$emit("update:modelValue", this.toggleState);
        },
    },
    created() {
        // ... give random id if not set
        if (this.id == "") {
            this.realId = md5(Math.random());
        } else {
            this.realId = this.id;
        }

        if (this.type == "toggle") {
            this.toggleState = this.modelValue;
        }
    },
    methods: {
        divisionStepClass(index) {
            if (this.type != "timeline") {
                return "";
            }

            if (index - 1 == this.modelValue) {
                return "text-lg text-gray-100 animate-pulse";
            }

            if (index < 26) {
                return "text-gray-700";
            }
            if (index == 26) {
                return "text-orange-500 text-lg";
            }

            if (index > 26 && index < 81) {
                return "text-gray-400";
            }

            if (index == 81) {
                return "text-orange-400 text-lg";
            }

            if (index > 81 && index < 93) {
                return "text-red-200";
            }

            return "text-gray-700";
        },
    },
};
</script>

<style scoped>
input[type="range"][orient="vertical"] {
    appearance: slider-vertical;
    width: 8px;
    padding: 0 5px;
}
</style>
