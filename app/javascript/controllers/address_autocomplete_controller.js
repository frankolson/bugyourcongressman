import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    if (!window.google) {
      console.error('[address-autocomplete]: Google script not loaded')
      return;
    }

    if (!window.google.maps) {
      console.error('[address-autocomplete]: Google maps script not loaded')
      return;
    }

    if (!window.google.maps.places) {
      console.error('[address-autocomplete]: Google maps places script not loaded')
      return;
    }

    new window.google.maps.places.Autocomplete(
      /** @type {!HTMLInputElement} */
      this.element,
      { types: ['geocode'] }
    )
  }

  get googleApiKey() {

  }
}
