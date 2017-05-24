import { Component } from '@angular/core';

@Component({
  selector: 'my-app',
  template: `<h1>Hello {{name}}</h1><p>Last comment removed ... oh my... you can see me!! </p>`,
})
export class AppComponent  { name = 'Angular'; }
