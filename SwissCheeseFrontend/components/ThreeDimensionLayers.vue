<template>
    <div class="layer-container stacked-top">
        <div @click="havefun" class="layer bottom-layer">
            <TwoDimensionalMap :people="50" :height="800" :width="1000">
                <img src="/floorplan3.jpg" alt="Floorplan">
            </TwoDimensionalMap>
        </div>
        <div @click="havefun" class="layer mid-layer">
            <TwoDimensionalMap :people="40" :height="800" :width="1000">
                <img src="/sketch.jpg" alt="Floorplan">
            </TwoDimensionalMap>
        </div>
        <div @click="havefun" class="layer top-layer">
            <TwoDimensionalMap :people="10" :height="800" :width="1000">
                <img src="/floorplan3.jpg" alt="Floorplan">
            </TwoDimensionalMap>
        </div>
    </div>
</template>

<script setup>
onMounted(() => {
    $(document).ready(function () {
        $(".layer").click(function () {
            if ($(this).hasClass("top-layer")) {
                return false;
            }
            if ($(this).hasClass("bottom-layer")) {
                $(this).addClass("bottom");
            }

            $(this).removeClass("bottom-layer").removeClass("mid-layer").addClass("animate").addClass("top-layer");
            $(this).siblings(".mid-layer").removeClass("bottom").removeClass("mid-layer").removeClass("animate").addClass("bottom-layer");
            $(this).siblings(".top-layer").removeClass("bottom").removeClass("top-layer").removeClass("animate").addClass("mid-layer");
        });
    });
})
</script>

<style scoped>
body {
    margin: 0;
}

.layer-container {
    width: 400px;
    height: 400px;
    position: absolute;
    top: 50%;
    left: 50%;
    margin: -100px 0 0 -250px;
    perspective: 500px;
    transform-style: preserve-3d;
}

.layer {
    width: 500px;
    height: 250px;
    position: absolute;
    transition: all 1.5s ease-in-out;
    cursor: pointer;
    z-index: 1;
}

.bottom-layer {
    transform: rotateX(45deg) rotateZ(0deg) translateZ(0);
}

.mid-layer {
    transform: rotateX(45deg) rotateZ(0deg) translateZ(20px);
}

.top-layer {
    transform: rotateX(45deg) rotateZ(0deg) translateZ(40px);
}

@keyframes stack-move-top-3d {
    0% {
        transform: rotateX(45deg) rotateZ(45deg) translateZ(100px);
    }

    50% {
        transform: rotateX(45deg) rotatey(90deg) rotateZ(45deg) translate3d(-50px, 100px, 170px);
    }

    100% {
        transform: rotateX(45deg) rotateZ(45deg) translateZ(200px);
    }
}

.animate {
    animation: stack-move-top-3d 1.5s ease-in-out;
}

/*animation for bottom-layer*/

.bottom.animate {
    animation: bottom-move-top-3d 1.5s ease-in-out;
}

@keyframes bottom-move-top-3d {
    0% {
        transform: rotateX(45deg) rotateZ(45deg) translateZ(0px);
    }

    50% {
        transform: rotateX(45deg) rotatey(90deg) rotateZ(45deg) translate3d(-50px, 100px, 170px);
    }

    100% {
        transform: rotateX(45deg) rotateZ(45deg) translateZ(200px);
    }
}
</style>