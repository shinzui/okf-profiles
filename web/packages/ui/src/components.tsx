// React Aria primitives, styled for shadcn/ui aria-nova (MIT).
import {
  Button as AriaButton,
  Link as AriaLink,
  SearchField as AriaSearchField,
  Input,
  Label,
  Dialog,
  Modal,
  ModalOverlay,
  DialogTrigger,
} from "react-aria-components"
import type { ComponentProps, ReactNode } from "react"
export function Button(props: ComponentProps<typeof AriaButton>) {
  return <AriaButton {...props} className="button" />
}
export function Link(props: ComponentProps<typeof AriaLink>) {
  return <AriaLink {...props} className="link" />
}
export function SearchField({
  value,
  onChange,
}: {
  value: string
  onChange: (value: string) => void
}) {
  return (
    <AriaSearchField value={value} onChange={onChange}>
      <Label>Search documents</Label>
      <Input placeholder="Profiles, types, or fields…" />
    </AriaSearchField>
  )
}
export function NavigationDialog({ children }: { children: ReactNode }) {
  return (
    <DialogTrigger>
      <Button aria-label="Open navigation">Menu</Button>
      <ModalOverlay className="overlay" isDismissable>
        <Modal className="modal">
          <Dialog aria-label="Navigation">
            {({ close }) => (
              <>
                <Button onPress={close}>Close navigation</Button>
                <div
                  onClick={(e) => {
                    if ((e.target as HTMLElement).closest("a")) close()
                  }}
                >
                  {children}
                </div>
              </>
            )}
          </Dialog>
        </Modal>
      </ModalOverlay>
    </DialogTrigger>
  )
}
