import { WebPlugin } from '@capacitor/core';

import type { ApplePayPlugin } from './definitions';

export class ApplePayWeb extends WebPlugin implements ApplePayPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }

  async canMakePayments(): Promise<{ canMakePayments: boolean }> {
    return { canMakePayments: false };
  }
}
