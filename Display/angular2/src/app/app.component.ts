import { Component } from '@angular/core';

@Component({
  selector: 'my-app',
  template: `<h1>Hello {{name}}</h1><p>I Love You!</p>`,
})
export class AppComponent  { name = 'Angular'; }
