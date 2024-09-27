export interface PaymentSummaryItem {
  label: string;
  amount: string;
}
export interface ApplePayRequestOptions {
  merchantId: string;
  countryCode: string;
  currencyCode: string;
  supportedNetworks: string[];
  merchantCapabilities: string[];
  paymentSummaryItems: PaymentSummaryItem[];
}

export interface ApplePayPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  canMakePayments(): Promise<{ canMakePayments: boolean }>;
  showApplePaySheet(options: ApplePayRequestOptions): Promise<{ success: boolean }>;

}
