export class Float3 {

    elements = new Float32Array(3);

    get x(): number { return this.elements[0]; }
    set x(value: number) { this.elements[0] = value }
    get y(): number { return this.elements[1]; }
    set y(value: number) { this.elements[1] = value }
    get z(): number { return this.elements[2]; }
    set z(value: number) { this.elements[2] = value }

    constructor(x?: number, y?: number, z?: number) {
        this.x = x ?? 0;
        this.y = y ?? 0;
        this.z = z ?? 0;
    }

    set(x: number, y: number, z: number) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

}