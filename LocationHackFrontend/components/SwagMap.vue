<template>
    <div class="max-w-xl overflow-hidden mx-auto relative">
        <div class="py-12">
            <div id="embed-map" class="myMap rounded text-gray-900 min-h-[700px]" />
        </div>
    </div>
</template>

<script>
import "mapbox-gl/dist/mapbox-gl.css";
import mapboxgl from "mapbox-gl";

export default {
    mounted() {
        mapboxgl.accessToken = "pk.eyJ1IjoibWFzdGVycGVlcDQyMCIsImEiOiJjbDlobHV5M2sxMzlxM3dvMHBqN2EwcnFpIn0.HBA7B35Gen4J2bKR7jlasw";
        const geojson = {
            type: 'FeatureCollection',
            features: [
                {
                    type: 'Feature',
                    geometry: {
                        type: 'Point',
                        coordinates: [11.553240, 48.174874]
                    },
                    properties: {
                        title: 'Mapbox',
                        description: 'Washington, D.C.'
                    }
                },
                {
                    type: 'Feature',
                    geometry: {
                        type: 'Point',
                        coordinates: [11.553240, 48.174874]
                    },
                    properties: {
                        title: 'Mapbox',
                        description: 'San Francisco, California'
                    }
                }
            ]
        };
        let map = new mapboxgl.Map({
            container: 'embed-map',
            style: 'mapbox://styles/mapbox/standard-beta',
            center: [11.553240, 48.174874],
            zoom: 15.9,
            pitch: 60,
            bearing: 0
        });
        map.on('load', function () {
            // add markers to map
            for (const feature of geojson.features) {
                // create a HTML element for each feature
                const el = document.createElement('div');
                el.className = 'marker';

                // make a marker for each feature and add to the map
                new mapboxgl.Marker(el).setLngLat(feature.geometry.coordinates).addTo(map);
            }

        });
    }
}
</script>

<style>
.myMap {
    height: 350px;
}

.mapboxgl-popup-close-button {
    margin: 5px;
}

.mapbox-logo {
    display: none;
}

.mapboxgl-ctrl-logo {
    display: none !important;
}

.mapbox-improve-map {
    display: none;
}

.mapboxgl-ctrl-compass {
    display: none;
}

.marker {
    background-image: url('person.png');
    background-size: cover;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    cursor: pointer;
}
</style>
