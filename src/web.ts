import type { ListenerCallback, PluginListenerHandle } from '@capacitor/core';
import { WebPlugin } from '@capacitor/core';

import type { ApplePayPlugin, ApplePayRequestOptions } from './definitions';

export class ApplePayWeb extends WebPlugin implements ApplePayPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }

  async canMakePayments(): Promise<{ canMakePayments: boolean }> {
    return { canMakePayments: false };
  }

  async showApplePaySheet(options: ApplePayRequestOptions): Promise<{ success: boolean; }> {
      console.log('showApplePaySheet', options);
      return { success: false };
  }

  async showInAppPurchaseSheet(options: {productIdentifiers: string[]}): Promise<{ success: boolean; }> {
      console.log('showInAppPurchase', options);
      return { success: false };
  }

  async addListener(eventName: string, listenerFunc: ListenerCallback): Promise<PluginListenerHandle> {
    return super.addListener(eventName,listenerFunc);
  }

  async restoreInAppPurchase(): Promise<{ success: boolean }> {
    return { success: false };
  }
}
