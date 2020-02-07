/* global ga */

// Import CSS

import 'tachyons/css/tachyons.css';
import 'normalize-css';

import './scss/main.scss';

import Elm from './Main.elm';
const mountNode = document.getElementById('main');

// Get the current unix time
const now = Math.floor(new Date().getTime() / 1000);

// The third value on embed are the initial values for incomming ports into Elm
const app = Elm.Main.embed(mountNode, {
  prod  : process.env.NODE_ENV === 'production',
  apiKey: process.env.API_KEY || '',
  now
});

app.ports.changeMetadata.subscribe(title => {
  document.title = title;
});

app.ports.scrollToTop.subscribe(() => {
  window.scrollTo(0, 0);
});
