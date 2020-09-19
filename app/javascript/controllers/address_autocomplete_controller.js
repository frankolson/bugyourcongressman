import { Controller } from "stimulus"
import { Loader } from "@googlemaps/js-api-loader";

export default class extends Controller {
  connect() {
    const loader = new Loader({
      apiKey: this.data.get("googleKey"),
      libraries: ["places"]
    });

    loader
      .load()
      .then(() => {
        new google.maps.places.Autocomplete(
          /** @type {!HTMLInputElement} */
          this.element,
          { types: ['geocode'] }
        )
      })
      .catch(e => {
        console.error(e)
        return;
      });
  }
}
