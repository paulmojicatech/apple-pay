import type { ListenerCallback, PluginListenerHandle } from '@capacitor/core';

export type RecurringPaymentIntervalUnit = 'day' | 'week' | 'month' | 'year';

export interface PaymentSummaryItem {
  label: string;
  amount: string;
}

export interface RecurrentPaymentSummaryItem extends PaymentSummaryItem {
  startDate: string;
  intervalUnit: RecurringPaymentIntervalUnit;
  managementURL: string;
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
