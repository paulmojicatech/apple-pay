export interface ApplePayPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;

  canMakePayments(): Promise<{ canMakePayments: boolean }>;

}
