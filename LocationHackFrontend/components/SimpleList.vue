<template>
    <fieldset>
        <legend class="text-base font-semibold leading-6 text-gray-900 m-2">Members</legend>
        <div class="mt-4 divide-y divide-gray-200 border-b border-t border-gray-200 min-h-[400px] max-h-[400px]
            bg-gray-100 w-full p-2 rounded">
            <p v-if="persons.length == 0">
                Pin persons to message or call them
            </p>
            <div v-for="(person, personIdx) in persons" :key="personIdx" class="relative flex items-start py-4">
                <div class="min-w-0 flex-1 text-sm leading-6">
                    <label :for="`person-${person.id}`" class="select-none font-medium text-gray-900"><span
                            @click="$emit('unpin', person)" class="italic">x </span>{{ person.name
                        }}</label>
                </div>
                <a :href="`tel:${person.phone}`" type="button"
                    class="rounded-full bg-white px-3 py-1.5 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">Call</a>
                <a :href="`mailto: ${person.email}`" type="button"
                    class="rounded-full ml-2 bg-white px-3 py-1.5 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50">Send
                    message</a>
            </div>
        </div>
    </fieldset>
</template>

<script>
export default {
    props: {
        persons: {
            type: Array,
            default: () => []
        }
    }
}
</script>