import type { ListenerCallback, PluginListenerHandle } from '@capacitor/core';

export interface PaymentSummaryItem {
  label: string;
  amount: string;
}

export interface RecurrentPaymentSummaryItem extends PaymentSummaryItem {
  startDate: string;
  intervalUnit: string;
  managementUrl: string;
  intervalCount?: number;
}
export interface ApplePayRequestOptions {
  merchantId: string;
  countryCode: string;
  currencyCode: string;
  supportedNetworks: string[];
  merchantCapabilities: string[];
  paymentSummaryItems?: PaymentSummaryItem[];  
  recurringSummaryItems?: RecurrentPaymentSummaryItem[];
}

export interface ApplePayPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  canMakePayments(): Promise<{ canMakePayments: boolean }>;
  showApplePaySheet(options: ApplePayRequestOptions): Promise<{ success: boolean }>;
  addListener(eventName: string, listenerFunc: ListenerCallback): Promise<PluginListenerHandle>;
}
